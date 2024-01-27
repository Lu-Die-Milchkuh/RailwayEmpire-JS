USE Railway;

DROP TRIGGER IF EXISTS Train_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Train_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Train_Audit_Update_Trigger AFTER UPDATE ON Train
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Train_Audit (action, trainID, stationIDFK, cost, costPerDay, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.trainID, OLD.stationIDFK, OLD.cost, OLD.costPerDay, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Train_Audit_Delete_Trigger AFTER DELETE ON Train
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Train_Audit (action, trainID, stationIDFK, cost, costPerDay, mysql_user, timestamp)
    VALUES ('DELETE', OLD.trainID, OLD.stationIDFK, OLD.cost, OLD.costPerDay, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
