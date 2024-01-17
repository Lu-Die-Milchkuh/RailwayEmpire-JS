USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getTrainByID;

CREATE PROCEDURE sp_getTrainByID(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE v_trainID INT;
    DECLARE v_data JSON;
    DECLARE v_schema JSON;

    SET v_schema = '{
      "trainID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SET v_trainID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.trainID'));

    IF NOT EXISTS(SELECT * FROM Train WHERE trainID = v_trainID) THEN
        SELECT JSON_OBJECT('code', 404,
                           'message', 'Train not found',
                           'data', null) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
                   'trainID', trainID,
                   'stationIDFK', stationIDFK,
                   'cost', cost,
                   'costPerDay', costPerDay
           )
    into v_data
    FROM Train
    WHERE trainID = v_trainID;

    SELECT JSON_OBJECT('code', 200,
                       'message', null,
                       'data', v_data) as output;
END//

DELIMITER ;

