USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getPlayerByID;

CREATE PROCEDURE sp_getPlayerByID(IN id INT)
BEGIN
   SELECT
        JSON_OBJECT(
            'username', username,
            'funds', funds,
            'joinDate', joinDate
        ) as Player
    FROM User WHERE userID = id;
END$$

DELIMITER ;

CALL sp_getPlayerByID(8);