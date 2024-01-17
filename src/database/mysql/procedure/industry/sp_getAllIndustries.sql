USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllIndustries;

CREATE PROCEDURE sp_getAllIndustries(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE p_townID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = '{
      "assetID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET p_townID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));

    IF NOT EXISTS(SELECT * FROM Asset WHERE assetID = p_townID AND type = 'TOWN') THEN
        SELECT JSON_OBJECT(
                   'code', 404,
                   'message', 'Town does not exist',
                   'data', null
           ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'industryID', industryID,
                           'type', type,
                           'assetIDFK', assetIDFK
                   ))
    INTO v_data
    FROM Industry
    WHERE assetIDFK = p_townID;

    IF v_data IS NULL THEN
        SELECT JSON_OBJECT(
                   'code', 404,
                   'message', 'Town has no Industries',
                   'data', null
           ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
               'code', 200,
               'message', null,
               'data', v_data
       ) as output;
END$$

DELIMITER ;
