USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyBusiness;

CREATE PROCEDURE sp_buyBusiness(in p_jsonData JSON)
sp:
BEGIN
    DECLARE v_funds FLOAT;
    DECLARE v_cost FLOAT DEFAULT 250000;
    DECLARE v_assetID INT;
    DECLARE v_userID INT;
    DECLARE V_schema JSON;

    DECLARE v_data JSON;

    SET v_schema = '{
      "userID": "integer",
      "assetID": "integer"
    }';

     IF NOT JSON_VALID(p_jsonData)  OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData)  THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));
    SET v_assetID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));

    -- Check if the User exists
    IF NOT EXISTS(SELECT * FROM User WHERE userID = v_userID) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'User not found',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    -- Check if the Asset exists
    IF NOT EXISTS(SELECT * FROM Asset WHERE assetID = v_assetID) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'Asset not found',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    SELECT funds INTO v_funds FROM user WHERE userID = v_userID;
    SELECT cost INTO v_cost FROM Asset WHERE assetID = v_assetID;

    IF v_funds < v_cost THEN
        SELECT JSON_OBJECT(
                       'code', 402,
                       'message', 'Insufficient funds',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    UPDATE User SET funds = v_funds - v_cost WHERE userID = v_userID;
    UPDATE Asset SET userIDFK = v_userID WHERE assetID = v_assetID;

    SELECT JSON_OBJECT(
                   'assetID', assetID,
                   'name', name,
                   'userID', userIDFK,
                   'type', type,
                   'position', position,
                   'cost', cost
           )
    INTO v_data
    FROM Asset
    WHERE assetID = v_assetID;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;
    LEAVE sp;
END$$

DELIMITER ;