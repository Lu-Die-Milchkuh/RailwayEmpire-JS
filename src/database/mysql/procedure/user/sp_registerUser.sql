USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_registerUser;

CREATE PROCEDURE sp_registerUser(IN p_jsonData JSON)
sp:
BEGIN

    DECLARE v_username VARCHAR(255);
    DECLARE v_password VARCHAR(255);
    DECLARE v_worldID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;
    DECLARE v_freeWorld INT;

    SET v_schema = JSON_OBJECT(
            'username', 'string',
            'password', 'string'
                   );

    IF NOT (JSON_VALID(p_jsonData)) OR NOT (JSON_SCHEMA_VALID(v_schema, p_jsonData)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    -- Check if there is a free world
    CALL sp_getFreeWorld(v_freeWorld);

    IF v_freeWorld = 0 THEN
        CALL sp_createWorld();
    END IF;


    SELECT MAX(worldID) INTO v_worldID FROM World;

    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.username'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.password'));

    IF EXISTS (SELECT username FROM User WHERE username = v_username) THEN
        SELECT JSON_OBJECT(
                       'code', 401,
                       'message', 'Username already taken',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    -- Insert the new user into the User table with the worldID
    INSERT INTO Railway.User (username, password, joinDate, worldIDFK)
    VALUES (v_username, v_password, CURRENT_TIMESTAMP, v_worldID);

    SELECT JSON_OBJECT(
                   'worldID', v_worldID,
                'userID', LAST_INSERT_ID()
           )
    INTO v_data;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', 'User registered successfully',
                   'data', v_data
           ) as output;

END$$

DELIMITER ;
