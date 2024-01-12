USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getDistance;

CREATE PROCEDURE sp_getDistance(IN p_fromStation INT, IN p_toStation INT)
BEGIN
    DECLARE srcPos POINT;
    DECLARE destPos POINT;
    DECLARE distance FLOAT;


    -- Get the position of the source station
    SELECT A.position INTO srcPos
    FROM Asset A
    INNER JOIN Station S ON A.assetID = S.assetIDFK
    WHERE S.stationID = p_fromStation;

    -- Get the position of the destination station
    SELECT A.position INTO destPos
    FROM Asset A
    INNER JOIN Station S ON A.assetID = S.assetIDFK
    WHERE S.stationID = p_toStation;

    -- Calculate the distance using the distance function (assuming you have a function to calculate distance)
    -- The exact function might depend on your database system, for example, you can use ST_DISTANCE for MySQL
    -- This example assumes a hypothetical DISTANCE_FUNCTION, replace it with the appropriate function for your database.

    SET distance = ROUND(
                    SQRT(
                        POW(ST_X(destPos) - ST_X(srcPos),2) +
                        POW(ST_Y(destPos) - ST_Y(srcPos),2)
                    ), 2);

    -- You can now use the 'distance' variable for further processing or return it as needed.
    SELECT distance AS Distance;
END//

DELIMITER ;
