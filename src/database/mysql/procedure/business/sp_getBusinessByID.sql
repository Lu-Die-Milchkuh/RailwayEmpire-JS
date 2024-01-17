USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getBusinessByID;


CREATE PROCEDURE sp_getBusinessByID(IN p_jsonData JSON)
sp:BEGIN
    DECLARE v_schema JSON;
    DECLARE v_businessID INT;
    DECLARE v_data JSON;
    DECLARE temp_businessID INT;

    SET v_schema = '{
      "assetID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData)  OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData)  THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_businessID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));

    SELECT assetID INTO temp_businessID FROM Asset WHERE assetID = v_businessID AND type != 'TOWN';

    IF temp_businessID IS NULL THEN
        SELECT JSON_OBJECT(
                   'code', 404,
                   'message', 'Business not found',
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
    WHERE type != 'TOWN'
      AND assetID = v_businessID;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data
           ) as output;
END //
