USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getAllTrains;

CREATE PROCEDURE sp_getAllTrains(IN p_jsonData JSON)
sp:BEGIN

    DECLARE v_stationID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = '{
      "stationID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;

    SET v_stationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.stationID'));

    -- Check if the Station exists
    IF NOT EXISTS(SELECT * FROM Station WHERE stationID = v_stationID) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'Station does not exist',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'trainID', trainID,
                           'stationIDFK', stationIDFK,
                           'cost', cost,
                           'costPerDay', costPerDay
                   )
           )
    INTO v_data
    FROM Train
    WHERE stationIDFK = v_stationID;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;

END //