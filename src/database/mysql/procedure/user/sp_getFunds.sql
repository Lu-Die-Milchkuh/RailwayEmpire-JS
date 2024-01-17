USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getFunds;

CREATE PROCEDURE sp_getFunds(IN p_jsonData JSON)
BEGIN
    DECLARE v_userID INT;
    DECLARE v_schema JSON;

    SET v_schema = '{
      "userID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData)  THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));

    SELECT JSON_OBJECT('funds', funds) as output FROM User WHERE userID = v_userID;
END//

DELIMITER ;


