USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyIndustry;

CREATE PROCEDURE sp_buyIndustry(IN jsonData JSON)
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
    DECLARE v_data JSON;

    SET v_schema = '{
      "userID": "integer",
      "assetID": "integer",
      "type": "string"
    }';

    IF NOT (JSON_VALID(jsonData)) OR NOT JSON_SCHEMA_VALID(v_schema, jsonData) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;


    SET v_townID = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.assetID'));
    SET v_industryType = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.type'));
    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.userID'));

    -- TODO: Check how many Industries the Town can have

    SELECT funds INTO v_funds FROM User WHERE userID = v_userID;
    SELECT cost INTO v_industryCost FROM Industry WHERE assetIDFK = v_townID;

    IF ((v_funds - v_industryCost) < 0) THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'Not enough funds',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    UPDATE User SET funds = v_funds - v_industryCost WHERE userID = v_userID;

    INSERT INTO Industry (assetIDFK) VALUES (v_townID);

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', null -- TODO: Add data
           ) as output;
END$$

DELIMITER ;
