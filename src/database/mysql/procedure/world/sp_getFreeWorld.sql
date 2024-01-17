USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getFreeWorld;

CREATE PROCEDURE sp_getFreeWorld(OUT isFree INT)
BEGIN
     DECLARE freeWorldCount INT;

    SELECT COUNT(*) INTO freeWorldCount
    FROM World w
    LEFT JOIN (
        SELECT worldIDFK, COUNT(*) AS numPlayers
        FROM User
        GROUP BY worldIDFK
    ) u ON w.worldID = u.worldIDFK
    WHERE COALESCE(numPlayers, 0) < 5;

    -- Set isFree based on the count
    SET isFree = CASE WHEN freeWorldCount > 0 THEN 1 ELSE 0 END;
END$$

DELIMITER ;

CALL sp_getFreeWorld(@isFree);
SELECT @isFree;

