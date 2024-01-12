USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getAllStations;


CREATE PROCEDURE sp_getAllStations(IN p_assetID INT)
BEGIN
    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'stationID', stationID,
                           'assetIDFK', assetIDFK
                   )
           ) as Stations
    FROM Station WHERE assetIDFK = p_assetID;
END //

DELIMITER ;
