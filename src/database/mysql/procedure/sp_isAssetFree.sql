USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_isAssetFree;

CREATE PROCEDURE sp_isAssetFree(IN p_jsonData JSON)
BEGIN
    DECLARE v_assetID INT;
    DECLARE v_schema JSON;

    SET v_schema = '{
        "assetID": "integer"
    }';

    IF JSON_VALID(p_jsonData) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    IF JSON_SCHEMA_VALID(v_schema, p_jsonData) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON schema';
    END IF;

    SET v_assetID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));

    SELECT userIDFK as Owner FROM Asset WHERE assetID = v_assetID;
END$$

DELIMITER ;

