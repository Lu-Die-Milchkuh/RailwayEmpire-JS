USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getPlayerByID;

CREATE PROCEDURE sp_getPlayerByID(IN p_jsonData JSON)
BEGIN
    DECLARE v_userID INT;
    DECLARE v_schema JSON;

    SET v_schema = '{
      "userID": "integer"
    }';

    IF JSON_VALID(p_jsonData) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON data';
    END IF;

    IF JSON_SCHEMA_VALID(v_schema, p_jsonData) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid JSON schema';
    END IF;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));

    SELECT JSON_OBJECT(
                   'userID', userID,
                   'username', username,
                   'funds', funds,
                   'joinDate', joinDate
           )
    FROM User
    WHERE userID = v_userID;
END$$

DELIMITER ;
