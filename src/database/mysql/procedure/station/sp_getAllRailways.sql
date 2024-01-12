USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getAllRailways;

CREATE PROCEDURE sp_getAllRailways(IN p_stationID INT)
BEGIN
    SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'trackID', t.trackID,
        'stationID1FK', t.stationID1FK,
        'stationID2FK', t.stationID2FK
    )) AS Tracks
    FROM Track t
    WHERE Track.stationID1FK = p_stationID OR Track.stationID2FK = p_stationID;
END //

DELIMITER ;
