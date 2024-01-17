USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllAssets;

CREATE PROCEDURE sp_getAllAssets(IN p_jsonData JSON)
sp:
BEGIN

    DECLARE p_worldID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = '{
      "worldID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET p_worldID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.worldID'));

    -- Check if the World exists
    IF NOT EXISTS(SELECT * FROM World WHERE worldID = p_worldID) THEN

        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'World does not exist',
                       'data ', null
               ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'assetID', assetID,
                           'type', type,
                           'population', population,
                           'position', JSON_OBJECT(
                                   'x', ST_X(position),
                                   'y', ST_Y(position)
                                       ),
                           'level', level,
                           'cost', cost,
                           'costPerDay', costPerDay,
                           'userID', userIDFK,
                           'worldID', worldIDFK
                   )
           )
    INTO v_data
    FROM Asset
    WHERE worldIDFK = p_worldID;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;

END$$

DELIMITER ;


