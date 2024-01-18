USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_createRoute;

CREATE PROCEDURE sp_createRoute(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE v_sourcePosition INT;
    DECLARE v_destinationPosition INT;
    DECLARE v_sourceStation INT;
    DECLARE v_distance FLOAT;
    DECLARE v_daysLeft INT;
    DECLARE v_schema JSON;

    DECLARE v_trainID INT;
    DECLARE v_stationID INT;
    DECLARE v_userID INT;

    SET v_schema = '{
      "userID": "integer",
      "trainID": "integer",
      "stationID": "integer"
    }';

    -- Validate the JSON
    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_trainID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.trainID'));
    SET v_stationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.stationID'));
    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));

    IF v_trainID IS NULL OR v_stationID IS NULL OR v_userID IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    -- Check if Train exists
    IF NOT EXISTS (SELECT * FROM Train WHERE trainID = v_trainID) THEN
        SELECT JSON_OBJECT('code', 404,
                           'message', 'Train does not exist',
                           'data', null) AS output;
        LEAVE sp;
    END IF;

    -- Check if Destination Station exists
    IF NOT EXISTS (SELECT * FROM Station WHERE stationID = v_stationID) THEN
        SELECT JSON_OBJECT('code', 404,
                           'message', 'Destination Station does not exist',
                           'data', null) AS output;
        LEAVE sp;
    END IF;

    -- Get Source Station
    SELECT stationIDFK INTO v_sourceStation FROM Train WHERE trainID = v_trainID;

    -- Get the source station position
    SELECT A.position
    INTO v_sourcePosition
    FROM Train T
             JOIN Station S ON T.stationIDFK = S.stationID
             JOIN Asset A ON S.assetIDFK = A.assetID
    WHERE T.trainID = v_trainID;

    -- Check if the train is already on a route
    IF EXISTS (SELECT * FROM Route WHERE trainIDFK = v_trainID) THEN
        SELECT JSON_OBJECT('code', 401,
                           'message', 'Train already has a route',
                           'data', null) AS output;
        LEAVE sp;
    END IF;

    -- Check if both Stations are connected via a Railway
    IF NOT EXISTS (SELECT * FROM Track WHERE stationID1FK = v_sourceStation AND stationID2FK = v_stationID) THEN
        SELECT JSON_OBJECT('code', 404,
                           'message', 'No Railway between the stations',
                           'data', null) AS output;
        LEAVE sp;
    END IF;

    -- Get destination position
    SELECT A.position
    INTO v_destinationPosition
    FROM Station S
             JOIN Asset A ON S.assetIDFK = A.assetID
    WHERE S.stationID = v_stationID;


    SET v_distance = ST_DISTANCE(v_sourcePosition, v_stationID);
    SET v_daysLeft = v_distance / 50;

    INSERT INTO Route (trainIDFK, stationIDFK, daysLeft) VALUES (v_trainID, v_stationID, v_daysLeft);

    SELECT JSON_OBJECT('code', 200,
                       'message', null,
                       'data', null) AS output;

END //

DELIMITER ;