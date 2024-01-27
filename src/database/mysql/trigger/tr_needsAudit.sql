USE Railway;

DROP TRIGGER IF EXISTS Needs_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Needs_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Needs_Audit_Update_Trigger AFTER UPDATE ON Needs
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Needs_Audit (action, assetIDFK, goodIDFK, amount, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.assetIDFK, OLD.goodIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Needs_Audit_Delete_Trigger AFTER DELETE ON Needs
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Needs_Audit (action, assetIDFK, goodIDFK, amount, mysql_user, timestamp)
    VALUES ('DELETE', OLD.assetIDFK, OLD.goodIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
