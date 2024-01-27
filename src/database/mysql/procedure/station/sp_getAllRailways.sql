USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getAllRailways;

CREATE PROCEDURE sp_getAllRailways(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE v_stationID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = '{
      "stationID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData)  THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_stationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.stationID'));

    IF v_stationID IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'stationID cannot be null';
    END IF;

    IF NOT EXISTS(SELECT * FROM Station WHERE Station.stationID = v_stationID) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'Station not found',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    IF NOT EXISTS(SELECT * FROM Track WHERE Track.stationID1FK = v_stationID OR Track.stationID2FK = v_stationID) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'No tracks found',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_ARRAYAGG(JSON_OBJECT(
            'trackID', trackID,
            'stationID1FK', stationID1FK,
            'stationID2FK', stationID2FK
                         )) INTO v_data
    FROM Track
    WHERE stationID1FK = v_stationID
       OR stationID2FK = v_stationID;

    SELECT JSON_OBJECT(
               'code', 200,
               'message', null,
               'data', v_data
       ) as output;
END //

DELIMITER ;
