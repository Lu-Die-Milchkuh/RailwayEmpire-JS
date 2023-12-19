USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getWorldById;

CREATE PROCEDURE sp_getWorldById(IN id INT)
BEGIN
    -- Declare variables to hold world information
    DECLARE v_world_id INT;
    DECLARE v_creation_date DATETIME;
    DECLARE v_number_of_players INT;
    DECLARE v_players_json JSON;

    -- Select world information based on the given worldID
    SELECT worldID, creationDate
    INTO v_world_id, v_creation_date
    FROM World
    WHERE worldID = id;

    -- Check if the world with the specified ID exists
    IF v_world_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'World not found';
    END IF;

    -- Select all players in the specified world as JSON array
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT('userID',userID, 'username', username, 'funds', funds,'joinDate', joinDate)
    )     INTO v_players_json
    FROM User
    WHERE worldIDFK = v_world_id;

    -- Return world information and players as a JSON object
    SELECT JSON_OBJECT(
        'worldID', v_world_id,
        'creationDate', v_creation_date,
        'players', v_players_json
    ) as world;

END$$

DELIMITER ;

#CALL sp_getWorldById(1);

