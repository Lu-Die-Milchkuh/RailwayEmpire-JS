USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAssetCost;

CREATE PROCEDURE sp_getAssetCost(IN p_jsonData JSON)
BEGIN
    DECLARE v_assetID INT;
    DECLARE v_schema JSON;

    SET v_schema ='{
        "assetID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;


    SET v_assetID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.assetID'));

    -- SELECT cost as Cost FROM Asset WHERE assetID = v_assetID;
    SELECT JSON_OBJECT('cost', cost) as output FROM Asset WHERE assetID = v_assetID;
END$$

DELIMITER ;

