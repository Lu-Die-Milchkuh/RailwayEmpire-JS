USE Railway;

DROP TRIGGER IF EXISTS Industry_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Industry_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Industry_Audit_Update_Trigger AFTER UPDATE ON Industry
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Industry_Audit (action, industryID, type, assetIDFK, cost, costPerDay, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.industryID, OLD.type, OLD.assetIDFK, OLD.cost, OLD.costPerDay, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Industry_Audit_Delete_Trigger AFTER DELETE ON Industry
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Industry_Audit (action, industryID, type, assetIDFK, cost, costPerDay, mysql_user, timestamp)
    VALUES ('DELETE', OLD.industryID, OLD.type, OLD.assetIDFK, OLD.cost, OLD.costPerDay, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
