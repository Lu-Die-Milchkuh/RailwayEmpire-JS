USE Railway;

DROP TRIGGER IF EXISTS User_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS User_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER User_Audit_Update_Trigger AFTER UPDATE ON User
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.User_Audit (action, userID, username, password, funds, joinDate, worldIDFK, user_action, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.userID, OLD.username, OLD.password, OLD.funds, OLD.joinDate, OLD.worldIDFK, 'UPDATE', CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER User_Audit_Delete_Trigger AFTER DELETE ON User
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.User_Audit (action, userID, username, password, funds, joinDate, worldIDFK, user_action, mysql_user, timestamp)
    VALUES ('DELETE', OLD.userID, OLD.username, OLD.password, OLD.funds, OLD.joinDate, OLD.worldIDFK, 'DELETE', CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
