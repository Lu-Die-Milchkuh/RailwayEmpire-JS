USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_loginUser`;

CREATE PROCEDURE `sp_loginUser`(IN user JSON)
BEGIN
    DECLARE v_username VARCHAR(255);
    DECLARE v_password VARCHAR(255);

    IF NOT(JSON_VALID(user)) THEN 
        SIGNAL SQLSTATE '45000'
	    SET MESSAGE_TEXT = 'Invalid JSON';
	END IF;

    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(user, '$.username'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(user, '$.password'));

    IF v_username IS NULL OR v_password IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SELECT * FROM User WHERE username = v_username AND password = v_password;

END$$

DELIMITER ;

CALL sp_loginUser('{"username": "foo", "password": "$2b$10$SaNEAf/LnwHaVQ1sT8rsYu5DPlgKMfGiI014.pWOP8aPh9ulD9qxG"}');
