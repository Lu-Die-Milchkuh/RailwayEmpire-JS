USE Railway;

DROP TRIGGER IF EXISTS Station_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Station_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Station_Audit_Update_Trigger AFTER UPDATE ON Station
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Station_Audit (action, stationID, assetIDFK, cost, costPerDay, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.stationID, OLD.assetIDFK, OLD.cost, OLD.costPerDay, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Station_Audit_Delete_Trigger AFTER DELETE ON Station
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Station_Audit (action, stationID, assetIDFK, cost, costPerDay, mysql_user, timestamp)
    VALUES ('DELETE', OLD.stationID, OLD.assetIDFK, OLD.cost, OLD.costPerDay, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
