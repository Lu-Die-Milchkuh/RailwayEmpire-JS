USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_registerUser`;

CREATE PROCEDURE `sp_registerUser`(IN user JSON)
BEGIN

	DECLARE v_username VARCHAR(255);
	DECLARE v_password VARCHAR(255);
    DECLARE v_worldID INT;

   
	#DECLARE userSchema JSON DEFAULT '{
	#					        "username": "",
	#					        "password": "",
	#					    }';

	IF NOT(JSON_VALID(user)) THEN 
        SIGNAL SQLSTATE '45000'
	    SET MESSAGE_TEXT = 'Invalid JSON';
	END IF;

    # Fedora 39 doesn't have a recent enough version of MariaDB...
	#IF NOT(JSON_SCHEMA_VALID(userSchema, user)) THEN
    #    SIGNAL SQLSTATE '45000'
	#    SET MESSAGE_TEXT = 'Invalid JSON Schema';
	#END IF;

	SET v_username = JSON_EXTRACT(user, '$.username');
	SET v_password = JSON_EXTRACT(user, '$.password');

    IF v_username IS NULL OR v_password IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON Schema';
    END IF;

    SELECT worldID INTO v_worldID FROM World WHERE numberOfPlayers < 20 ORDER BY creationDate LIMIT 1;

    -- If no world is found, create a new one
    IF v_worldID IS NULL THEN
        INSERT INTO World (creationDate, numberOfPlayers) VALUES (CURRENT_TIMESTAMP, 1);
        SET v_worldID = LAST_INSERT_ID();
    ELSE
        -- Increment the player count in the existing world
        UPDATE World SET numberOfPlayers = numberOfPlayers + 1 WHERE worldID = v_worldID;
    END IF;

    -- Insert the new user into the User table with the worldID
    INSERT INTO User (username, password, joinDate, worldIDFK) VALUES (v_username, v_password, CURRENT_TIMESTAMP, v_worldID);

    SELECT v_username, v_password, v_worldID AS worldID;
END $$

DELIMITER ;

#CALL sp_registerUser( '{"username": "test", "password": "test"}' );
