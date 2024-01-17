USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_createRoute;

CREATE PROCEDURE sp_createRoute(IN jsonData JSON)
BEGIN
    DECLARE v_sourcePosition INT;
    DECLARE v_destinationPosition INT;
    DECLARE v_distance FLOAT;
    DECLARE v_daysLeft INT;
    DECLARE v_schema JSON;

    DECLARE v_trainID INT;
    DECLARE v_stationID INT;

    SET v_schema = '{
      "trainID": "integer",
      "stationID": "integer"
    }';

    -- Validate the JSON
     IF NOT JSON_VALID(p_jsonData)  OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_trainID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.trainID'));
    SET v_stationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.stationID'));

    -- Get the source station position
    SELECT A.position
    INTO v_sourcePosition
    FROM Train T
             JOIN Station S ON T.stationIDFK = S.stationID
             JOIN Asset A ON S.assetIDFK = A.assetID
    WHERE T.trainID = v_trainID;


    -- Get the destination station position
    SELECT A.position
    INTO v_destinationPosition
    FROM Station S
             JOIN Asset A ON S.assetIDFK = A.assetID
    WHERE S.stationID = v_stationID;

    SET v_distance = ST_DISTANCE(v_sourcePosition, v_destinationPosition);
    SET v_daysLeft = v_distance / 50;

    INSERT INTO Route (trainIDFK, stationIDFK, daysLeft) VALUES (v_trainID, v_stationID, v_daysLeft);

END //

DELIMITER ;