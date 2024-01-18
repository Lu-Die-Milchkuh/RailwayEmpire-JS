USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getWorldById;

CREATE PROCEDURE sp_getWorldById(IN p_jsonData JSON)
sp:
BEGIN
    -- Declare variables to hold world information
    DECLARE v_world_id INT;
    DECLARE v_creation_date DATETIME;
    DECLARE v_players_json JSON;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = '{
      "worldID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_world_id = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.worldID'));

    IF NOT EXISTS(SELECT * FROM Railway.World WHERE worldID = v_world_id) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'World not found',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;


    -- Select world information based on the given worldID
    SELECT worldID, creationDate
    INTO v_world_id, v_creation_date
    FROM World
    WHERE worldID = v_world_id;

    -- Select all players in the specified world as JSON array
    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT('userID', userID, 'username', username, 'funds', funds, 'joinDate', joinDate)
           )
    INTO v_players_json
    FROM User
    WHERE worldIDFK = v_world_id;

    -- Return world information and players as a JSON object
    SELECT JSON_OBJECT(
                   'worldID', v_world_id,
                   'creationDate', v_creation_date,
                   'players', v_players_json
           )
    INTO v_data;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;

END$$

DELIMITER ;

CALL sp_getWorldById('{"worldID": 63}');



