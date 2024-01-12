USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getAllTrains;

CREATE PROCEDURE sp_getAllTrains(IN p_stationID INT)
BEGIN
    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                            'trainID', trainID,
                           'stationIDFK', stationIDFK,
                           'cost', cost,
                           'costPerDay', costPerDay
                   )
           )
    FROM Train
    WHERE stationIDFK = p_stationID;

END //