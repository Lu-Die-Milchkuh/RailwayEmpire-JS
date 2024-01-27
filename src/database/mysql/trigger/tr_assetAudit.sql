USE Railway;

DROP TRIGGER IF EXISTS Asset_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Asset_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Asset_Audit_Update_Trigger AFTER UPDATE ON Asset
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Asset_Audit (action, assetID, type, name, population, position, level, cost, costPerDay, worldIDFK, userIDFK, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.assetID, OLD.type, OLD.name, OLD.population, OLD.position, OLD.level, OLD.cost, OLD.costPerDay, OLD.worldIDFK, OLD.userIDFK, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Asset_Audit_Delete_Trigger AFTER DELETE ON Asset
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Asset_Audit (action, assetID, type, name, population, position, level, cost, costPerDay, worldIDFK, userIDFK, mysql_user, timestamp)
    VALUES ('DELETE', OLD.assetID, OLD.type, OLD.name, OLD.population, OLD.position, OLD.level, OLD.cost, OLD.costPerDay, OLD.worldIDFK, OLD.userIDFK, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
