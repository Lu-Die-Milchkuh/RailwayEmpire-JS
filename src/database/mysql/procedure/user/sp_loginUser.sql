USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_loginUser;

CREATE PROCEDURE sp_loginUser(IN p_jsonData JSON)
sp:BEGIN
    DECLARE v_username VARCHAR(255);
    DECLARE v_data JSON;
    DECLARE v_schema JSON;

    SET v_schema = JSON_OBJECT(
            'username', 'string',
            'password', 'string'
                   );

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema,p_jsonData) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.username'));

    IF NOT EXISTS(SELECT * FROM User WHERE username = v_username) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'User not found',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
                   'password', password,
                   'worldIDFK', worldIDFK
           )
    INTO v_data
    FROM User
    WHERE username = v_username;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;

END$$

DELIMITER ;

-- CALL sp_loginUser('{"username": "foo", "password": "$2b$10$8pEJZpovfTKbp37wACXWw.vJkn8qlinL6rr1F54MyNf.wOTSIWlnq"}');
-- CALL sp_loginUser('{"username": "test3"}');
CALL sp_loginUser('{
  "username": "foo2"
}');