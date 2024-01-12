USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getFreeWorld;

CREATE PROCEDURE sp_getFreeWorld()
BEGIN
    SELECT w.worldID as World
    FROM World w
    LEFT JOIN (
        SELECT worldIDFK, COUNT(*) AS numPlayers
        FROM User
        GROUP BY worldIDFK
    ) u ON w.worldID = u.worldIDFK
    WHERE COALESCE(numPlayers, 0) < 5
    ORDER BY w.creationDate
    LIMIT 1;
END$$

DELIMITER ;

CALL sp_getFreeWorld();