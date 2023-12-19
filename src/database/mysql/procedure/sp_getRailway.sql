USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getRailway;

CREATE PROCEDURE sp_getRailway(IN p_stationID INT)
BEGIN
    SELECT JSON_ARRAY(JSON_OBJECT('stationID1FK', stationID1FK, 'stationID2FK', stationID2FK))
    FROM Track as Tracks
    WHERE stationID1FK = p_stationID;
END$$

DELIMITER ;