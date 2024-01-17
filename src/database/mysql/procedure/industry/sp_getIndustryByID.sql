USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getIndustryByID;

CREATE PROCEDURE sp_getIndustryByID(IN p_jsonData JSON)
sp:BEGIN
    DECLARE v_schema JSON;
    DECLARE v_industryID INT;
    DECLARE v_data JSON;

    SET v_schema = '{
      "industryID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData)  OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_industryID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.industryID'));

    -- Check if Industry exists
    IF NOT EXISTS(SELECT industryID FROM Industry WHERE industryID = v_industryID) THEN
        SELECT JSON_OBJECT(
                'code', 404,
                'message', 'Industry not found',
                'data', null
        ) as output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
                   'industryID', industryID,
                   'type', type
           ) INTO v_data
    FROM Industry
    WHERE industryID = v_industryID;

    SELECT JSON_OBJECT(
            'code', 200,
            'message', null,
            'data', v_data
    ) as output;
END$$

DELIMITER $$