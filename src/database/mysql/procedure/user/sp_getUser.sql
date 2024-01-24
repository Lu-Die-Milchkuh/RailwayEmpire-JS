USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getUser;

CREATE PROCEDURE sp_getUser(IN p_jsonData JSON)
sp:BEGIN
    DECLARE v_token VARCHAR(255);
    DECLARE v_schema JSON;
    DECLARE v_userIDFK INT;

    SET v_schema = '{
      "token": "string"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_token = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.token'));

    IF NOT EXISTS(SELECT * FROM Token WHERE token = v_token) THEN
        SELECT JSON_OBJECT('found',false) as output;
        LEAVE sp;
    END IF;

    SELECT userIDFK INTO v_userIDFK FROM Token WHERE token = v_token LIMIT 1;

    SELECT JSON_OBJECT('found',true,'userID', userID, 'username', username) as output FROM User WHERE userID = v_userIDFK;
END//

DELIMITER ;

CALL sp_getUser('{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyIwIjoidCIsIjEiOiJlIiwiMiI6InMiLCIzIjoidCIsImV4cCI6MTcwNTQ5ODE0OX0.QONnEV8MSHGY6P-Gl7YRNLRqEuxOFyHT59qPPurS6Js"
}');

