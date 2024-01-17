USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getDistance;

CREATE PROCEDURE sp_getDistance(IN p_fromStation INT, IN p_toStation INT, OUT p_distance FLOAT)
BEGIN

    DECLARE srcPos POINT;
    DECLARE destPos POINT;
    DECLARE distance FLOAT;

    -- Get the position of the source station
    SELECT A.position
    INTO srcPos
    FROM Asset A
             INNER JOIN Station S ON A.assetID = S.assetIDFK
    WHERE S.stationID = p_fromStation;

    -- Get the position of the destination station
    SELECT A.position
    INTO destPos
    FROM Asset A
             INNER JOIN Station S ON A.assetID = S.assetIDFK
    WHERE S.stationID = p_toStation;

    SET distance = ROUND(
            SQRT(
                    POW(ST_X(destPos) - ST_X(srcPos), 2) +
                    POW(ST_Y(destPos) - ST_Y(srcPos), 2)
            ), 2);

    -- Set the output parameter
    SET p_distance = distance;
END//

DELIMITER ;
