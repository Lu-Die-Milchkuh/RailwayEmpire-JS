USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getStation;

CREATE PROCEDURE sp_getStation(IN p_jsonData JSON)
sp:BEGIN
    DECLARE v_schema JSON;
    DECLARE v_assetID INT;
    DECLARE v_data JSON;

     SET v_schema = '{
      "assetID": "integer"
    }';

    IF NOT (JSON_VALID(p_jsonData)) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;

    SET v_assetID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));

    -- Check if Asset exists
    IF NOT EXISTS (SELECT assetID FROM Asset WHERE assetID = v_assetID) THEN
        SELECT JSON_OBJECT(
               'code', 404,
               'message', 'Asset not found',
               'data', null
       ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
                   'stationID', stationID,
                   'assetIDFK', assetIDFK,
                   'cost', cost,
                   'costPerDay', costPerDay
           )
               INTO v_data
    FROM Station
    WHERE assetIDFK = v_assetID;

    IF v_data IS NULL THEN
        SELECT JSON_OBJECT(
               'code', 404,
               'message', 'This Asset has no Station yet',
               'data', null
       ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
               'code', 200,
               'message', null,
               'data', v_data
       ) as output;
END //

DELIMITER ;
