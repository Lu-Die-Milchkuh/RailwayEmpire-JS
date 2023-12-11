USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_loginUser;

CREATE PROCEDURE sp_loginUser(IN user JSON)
BEGIN
    DECLARE v_username VARCHAR(255);

    IF NOT(JSON_VALID(user)) THEN 
        SIGNAL SQLSTATE '45000'
	    SET MESSAGE_TEXT = 'Invalid JSON';
	END IF;

    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(user, '$.username'));

    IF v_username IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SELECT password FROM User WHERE username = v_username;

END$$

DELIMITER ;

-- CALL sp_loginUser('{"username": "foo", "password": "$2b$10$8pEJZpovfTKbp37wACXWw.vJkn8qlinL6rr1F54MyNf.wOTSIWlnq"}');
CALL sp_loginUser('{"username": "foo"}');
CALL sp_loginUser('{"username": "foo2"}');