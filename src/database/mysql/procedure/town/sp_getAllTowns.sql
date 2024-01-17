USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllTowns;

CREATE PROCEDURE sp_getAllTowns(IN p_jsonData JSON)
sp:BEGIN

    DECLARE v_worldID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = '{
      "worldID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData)  OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_worldID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.worldID'));

    IF EXISTS(SELECT * FROM World WHERE worldID = v_worldID) = 0 THEN
        SELECT JSON_OBJECT(
               'code', 404,
               'message', 'World not found',
               'data', null
       ) as output;
        LEAVE sp;
    END IF;

    IF EXISTS(SELECT * FROM Asset WHERE worldIDFK = v_worldID AND type = 'TOWN') = 0 THEN
        SELECT JSON_OBJECT(
               'code', 404,
               'message', 'No towns found',
               'data', null
       ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_ARRAYAGG(JSON_OBJECT('assetID', assetID,
                                     'name', name,
                                     'type', type,
                                     'population', population,
                                     'level', level,
                                     'userID', userIDFK,
                                     'level', level,
                                     'position', JSON_OBJECT('x', ST_X(position),
                                                             'y', ST_Y(position)),
                                     'worldID', worldIDFK,
                                     'cost', cost,
                                     'costPerDay', costPerDay
                         )) INTO v_data
    FROM Asset
    WHERE type = 'TOWN'
      AND worldIDFK = v_worldID;

    SELECT JSON_OBJECT(
               'code', 200,
               'message', null,
               'data', v_data
       ) as output;
END$$
