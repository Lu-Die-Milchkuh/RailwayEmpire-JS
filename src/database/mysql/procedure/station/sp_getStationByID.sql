USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getStationByID;

CREATE PROCEDURE sp_getStationByID(IN p_stationID INT)
BEGIN
    SELECT JSON_OBJECT(
                   'stationID', stationID,
                   'assetIDFK', assetIDFK,
                   'userID', (SELECT userIDFK FROM Asset WHERE assetID = assetIDFK)
           ) AS Station
    FROM Station
    WHERE stationID = p_stationID;
END //


DELIMITER ;
