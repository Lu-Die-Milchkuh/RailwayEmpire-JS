USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_saveToken;

CREATE PROCEDURE sp_saveToken(IN jsonData JSON)
BEGIN
    DECLARE v_username VARCHAR(255);
    DECLARE v_token VARCHAR(255);
    DECLARE v_idUser INT DEFAULT -1;

    IF NOT(JSON_VALID(jsonData)) THEN
        SIGNAL SQLSTATE '45000'
	    SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.username'));
	SET v_token = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.token'));

    IF v_username IS NULL OR v_token IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON Schema';
    END IF;

    SELECT userID INTO v_idUser FROM User WHERE username = v_username;

    INSERT INTO Token(userIDFK, token) VALUES(v_idUser,v_token);

END$$