USE Railway;

DROP TRIGGER IF EXISTS World_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS World_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER World_Audit_Update_Trigger AFTER UPDATE ON World
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.World_Audit (action, worldID, creationDate, user_action, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.worldID, OLD.creationDate, 'UPDATE', CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER World_Audit_Delete_Trigger AFTER DELETE ON World
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.World_Audit (action, worldID, creationDate, user_action, mysql_user, timestamp)
    VALUES ('DELETE', OLD.worldID, OLD.creationDate, 'DELETE', CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
