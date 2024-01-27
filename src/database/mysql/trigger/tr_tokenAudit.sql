USE Railway;

DROP TRIGGER IF EXISTS Token_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Token_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Token_Audit_Update_Trigger AFTER UPDATE ON Token
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Token_Audit (action, tokenID, userIDFK, token, created, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.tokenID, OLD.userIDFK, OLD.token, OLD.created, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Token_Audit_Delete_Trigger AFTER DELETE ON Token
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Token_Audit (action, tokenID, userIDFK, token, created, mysql_user, timestamp)
    VALUES ('DELETE', OLD.tokenID, OLD.userIDFK, OLD.token, OLD.created, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
