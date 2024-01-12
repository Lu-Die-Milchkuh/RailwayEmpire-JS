USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_createRoute;

CREATE PROCEDURE sp_createRoute(IN p_trainID INT, IN p_stationID INT)
BEGIN
    DECLARE v_sourcePosition INT;
    DECLARE v_destinationPosition INT;
    DECLARE v_distance FLOAT;
    DECLARE v_daysLeft INT;

    -- Get the source station position
    SELECT A.position INTO v_sourcePosition
    FROM Train T
    JOIN Station S ON T.stationIDFK = S.stationID
    JOIN Asset A ON S.assetIDFK = A.assetID
    WHERE T.trainID = p_trainID;


     -- Get the destination station position
    SELECT A.position INTO v_destinationPosition
    FROM Station S
    JOIN Asset A ON S.assetIDFK = A.assetID
    WHERE S.stationID = p_stationID;

    SET v_distance = ST_DISTANCE(v_sourcePosition, v_destinationPosition);
    SET v_daysLeft = v_distance / 50;

    INSERT INTO Route (trainIDFK, stationIDFK, daysLeft) VALUES (p_trainID, p_stationID, v_daysLeft);

END //

DELIMITER ;