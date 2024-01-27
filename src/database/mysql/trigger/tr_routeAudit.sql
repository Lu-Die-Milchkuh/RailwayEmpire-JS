USE Railway;

DROP TRIGGER IF EXISTS Route_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Route_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Route_Audit_Update_Trigger AFTER UPDATE ON Route
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Route_Audit (action, routeID, trainIDFK, stationIDFK, daysLeft, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.routeID, OLD.trainIDFK, OLD.stationIDFK, OLD.daysLeft, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Route_Audit_Delete_Trigger AFTER DELETE ON Route
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Route_Audit (action, routeID, trainIDFK, stationIDFK, daysLeft, mysql_user, timestamp)
    VALUES ('DELETE', OLD.routeID, OLD.trainIDFK, OLD.stationIDFK, OLD.daysLeft, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
