USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_registerUser;

CREATE PROCEDURE sp_registerUser(IN user JSON)
BEGIN

    DECLARE v_username VARCHAR(255);
    DECLARE v_password VARCHAR(255);
    DECLARE v_worldID INT;
    DECLARE v_numberOfPlayers INT;
    DECLARE v_lastWorldID INT;


    SELECT v_lastWorldID = LAST_INSERT_ID() FROM World;

    # 	DECLARE userSchema JSON DEFAULT '{
# 						        "username": "",
# 						        "password": "",
# 						    }';

    IF NOT (JSON_VALID(user)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;


    # 	IF NOT(JSON_SCHEMA_VALID(userSchema, user)) THEN
#         SIGNAL SQLSTATE '45000'
# 	    SET MESSAGE_TEXT = 'Invalid JSON Schema';
# 	END IF;

    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(user, '$.username'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(user, '$.password'));

    IF v_username IS NULL OR v_password IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON Schema';
    END IF;

    IF EXISTS (SELECT username FROM User WHERE username = v_username) THEN
        SIGNAL SQLSTATE '23000'
            SET MESSAGE_TEXT = 'Duplicate entry for username';
    END IF;

    SELECT MAX(worldID) INTO v_worldID FROM World;

    -- If no world is found, create a new one
    IF v_worldID IS NULL THEN
        CALL sp_createWorld(v_worldID);
    END IF;

    SELECT COUNT(*)
    INTO v_numberOfPlayers
    FROM World
             INNER JOIN Railway.User ON World.worldID = User.worldIDFK
    WHERE worldID = v_lastWorldID;
    -- SELECT worldID INTO v_worldID FROM World WHERE v_numberOfPlayers < 5 LIMIT 1;

    IF v_numberOfPlayers <= 5 THEN
        CALL sp_createWorld(v_worldID);
    END IF;

    -- Insert the new user into the User table with the worldID
    INSERT INTO Railway.User (username, password, joinDate, worldIDFK)
    VALUES (v_username, v_password, CURRENT_TIMESTAMP, v_worldID);

    SELECT v_username, v_password, v_worldID AS worldID;
END $$

DELIMITER ;

CALL sp_registerUser('{
  "username": "test1",
  "password": "test"
}');
CALL sp_registerUser('{
  "username": "test2",
  "password": "test"
}');
CALL sp_registerUser('{
  "username": "test3",
  "password": "test"
}');
CALL sp_registerUser('{
  "username": "test4",
  "password": "test"
}');
CALL sp_registerUser('{
  "username": "test5",
  "password": "test"
}');

CALL sp_registerUser('{
  "username": "test6",
  "password": "test"
}');

