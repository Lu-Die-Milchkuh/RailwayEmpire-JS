USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyIndustry;

CREATE PROCEDURE sp_buyIndustry(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE v_userID INT;
    DECLARE v_townID INT;
    DECLARE v_funds FLOAT;
    DECLARE v_industryCost FLOAT;
    DECLARE v_industryType ENUM (
        'BREWERY', 'BUTCHER', 'BAKERY', 'SAWMILL', 'CHEESEMAKER', 'CARPENTER','TAILOR',
        'SMELTER', 'SMITHY', 'JEWELER'
        );

    DECLARE v_schema JSON;
    DECLARE temp_userID INT;
    -- DECLARE v_data JSON;

    /* Mysql sucks so hard, "type" is a reserved keyword (that is why I use type1)
       I spend so much time debugging this shit, because the json validation
       failed even with valid json. I hate it so much. Why cant they just provide proper errors?!?!?
    */
    SET v_schema = '{
      "userID": "integer",
      "assetID": "integer",
      "type1": "string"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;

    SET v_townID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));
    SET v_industryType = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.type1'));
    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));

    IF v_townID IS NULL OR v_industryType IS NULL OR v_userID IS NULL THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'Missing parameters',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    -- Check if the User is the owner of the Town
    SELECT userIDFK INTO temp_userID FROM Asset WHERE assetID = v_townID LIMIT 1;

    IF temp_userID IS NULL OR temp_userID != v_userID THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'User is not the owner of the Town',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    -- TODO: Check how many Industries the Town can have

    SELECT funds INTO v_funds FROM User WHERE userID = v_userID;
    SELECT cost INTO v_industryCost FROM Industry WHERE assetIDFK = v_townID LIMIT 1;

    IF ((v_funds - v_industryCost) < 0) THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'Not enough funds',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    UPDATE User SET funds = v_funds - v_industryCost WHERE userID = v_userID;

    INSERT INTO Industry(assetIDFK, type) VALUES (v_townID, v_industryType);

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', null -- TODO: Add data
           ) as output;
END$$

DELIMITER ;
