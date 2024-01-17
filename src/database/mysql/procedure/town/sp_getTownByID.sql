USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getTownByID;

CREATE PROCEDURE sp_getTownByID(IN p_jsonData JSON)
sp:BEGIN

    DECLARE townID INT;
    DECLARE v_schema JSON;
    DECLARE tmp_townID INT;
    DECLARE v_data JSON;

    SET v_schema = '{
      "assetID": "integer"
    }';

     IF JSON_VALID(p_jsonData) = 0 OR JSON_SCHEMA_VALID(v_schema, p_jsonData) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET townID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));


    -- Check if Town exist
    IF NOT EXISTS(SELECT * FROM Asset WHERE assetID = townID AND type = 'Town') THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'Town not found',
                       'data', null
               ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT('assetID', assetID,
                       'type', type,
                       'name', name,
                       'population', population,
                       'position', JSON_OBJECT(
                               'x', ST_X(position),
                               'y', ST_Y(position)
                                   ),
                       'level', level,
                       'cost', cost,
                       'costPerDay', costPerDay,
                       'worldID', worldIDFK,
                       'userID', userIDFK
           ) INTO v_data
    FROM Asset
    WHERE assetID = townID
      AND type = 'Town';

    SELECT JSON_OBJECT(
                       'code', 200,
                       'message', null,
                       'data', v_data
               ) as output;
END$$

DELIMITER ;
