USE Railway;

DROP TRIGGER IF EXISTS Track_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Track_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Track_Audit_Update_Trigger AFTER UPDATE ON Track
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Track_Audit (action, trackID, stationID1FK, stationID2FK, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.trackID, OLD.stationID1FK, OLD.stationID2FK, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Track_Audit_Delete_Trigger AFTER DELETE ON Track
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Track_Audit (action, trackID, stationID1FK, stationID2FK, mysql_user, timestamp)
    VALUES ('DELETE', OLD.trackID, OLD.stationID1FK, OLD.stationID2FK, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
