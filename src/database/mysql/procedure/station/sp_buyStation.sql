USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyStation;

CREATE PROCEDURE sp_buyStation(IN p_jsonData JSON)
sp:BEGIN
    DECLARE v_funds FLOAT;
    DECLARE v_userID INT;
    DECLARE v_cost FLOAT DEFAULT 100000;
    DECLARE v_stationID INT;
    DECLARE v_schema JSON;
    DECLARE v_assetID INT;
    DECLARE v_data JSON;

    DECLARE tmp_userID INT;

    SET v_schema = '{
      "userID": "integer",
      "assetID": "integer"
    }';

    IF NOT (JSON_VALID(p_jsonData)) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;

    SET v_assetID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));
    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));

    SELECT userIDFK INTO tmp_userID FROM Asset WHERE assetID = v_assetID;
    SELECT funds INTO v_funds FROM User WHERE userID = v_userID;

    SELECT Station.stationID INTO v_stationID FROM Station WHERE assetIDFK = v_assetID;

    IF v_stationID IS NOT NULL
    THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'Asset has already a station',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    -- Check if the User actually owns the Asset
    IF tmp_userID IS NULL OR tmp_userID != v_userID
    THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'User does not own asset',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    IF v_funds < v_cost
    THEN
        SELECT JSON_OBJECT(
                       'code', 402,
                       'message', 'Insufficient funds',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    UPDATE User SET funds = v_funds - v_cost WHERE userID = v_userID;
    INSERT INTO Station (assetIDFK) VALUES (v_assetID);

    SET v_stationID = LAST_INSERT_ID();

    SELECT JSON_OBJECT(
                   'stationID', stationID,
                   'assetIDFK', assetIDFK,
                   'cost', cost,
                   'costPerDay', costPerDay
           )
    INTO v_data
    FROM Station
    WHERE stationID = v_stationID;


    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;
END$$

DELIMITER ;
