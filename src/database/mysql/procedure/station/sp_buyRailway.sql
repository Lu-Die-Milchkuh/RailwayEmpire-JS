USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyRailway;

CREATE PROCEDURE sp_buyRailway(IN jsonData JSON)
BEGIN

    DECLARE sourceStationID INT;
    DECLARE destinationStationID INT;

    IF NOT (JSON_VALID(jsonData)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SET sourceStationID = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.src'));
    SET destinationStationID = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.dst'));

    INSERT INTO Track (stationID1FK, stationID2FK) VALUES (sourceStationID, destinationStationID);
END$$

DELIMITER ;