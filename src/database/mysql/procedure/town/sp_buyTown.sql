USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyTown;

CREATE PROCEDURE sp_buyTown(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE v_userID INT;
    DECLARE v_townID INT;
    DECLARE v_townCost FLOAT;
    DECLARE v_funds FLOAT;
    DECLARE v_name VARCHAR(255);
    DECLARE v_schema JSON;
    DECLARE tmp_userID INT;
    DECLARE v_data JSON;

    SET v_schema = '{
      "userID": "integer",
      "assetID": "integer",
      "name": "string"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(P_jsonData, '$.userID'));
    SET v_townID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));
    SET v_name = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.name'));

    SELECT userIDFK INTO tmp_userID FROM Asset WHERE assetID = v_townID;

    IF tmp_userID IS NOT NULL THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'Town already owned',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    SELECT funds INTO v_funds FROM User WHERE userID = v_userID;
    SELECT cost INTO v_townCost FROM Asset WHERE assetID = v_townID;

    IF v_funds < v_townCost THEN
        SELECT JSON_OBJECT(
                       'code', 402,
                       'message', 'Insufficient funds',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    UPDATE User SET funds = (v_funds - v_townCost) WHERE userID = v_userID;
    UPDATE Asset SET userIDFK = v_userID WHERE assetID = v_townID;
    UPDATE Asset SET name = v_name WHERE assetID = v_townID;

    SELECT JSON_OBJECT(
                   'assetID', assetID,
                   'name', name,
                   'userID', userIDFK,
                   'type', type,
                   'level', level,
                   'population', population,
                   'position', JSON_OBJECT(
                           'x', ST_X(position),
                           'y', ST_Y(position)
                               ),
                   'cost', cost,
                   'costPerDay', costPerDay,
                   'worldID', worldIDFK
           )
    INTO v_data
    FROM Asset
    WHERE assetID = v_townID;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;
END$$

DELIMITER ;