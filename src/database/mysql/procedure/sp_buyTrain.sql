USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyTrain;

CREATE PROCEDURE sp_buyTrain(IN jsonData JSON)
BEGIN
    DECLARE v_sourceStationID INT;
    DECLARE v_destinationStationID INT;
    DECLARE v_distance INT;
    DECLARE v_cost INT;



END$$

DELIMITER ;