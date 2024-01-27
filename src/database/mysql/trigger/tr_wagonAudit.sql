USE Railway;

DROP TRIGGER IF EXISTS Wagon_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Wagon_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Wagon_Audit_Update_Trigger AFTER UPDATE ON Wagon
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Wagon_Audit (action, wagonID, trainIDFK, goodIDFK, amount, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.wagonID, OLD.trainIDFK, OLD.goodIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Wagon_Audit_Delete_Trigger AFTER DELETE ON Wagon
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Wagon_Audit (action, wagonID, trainIDFK, goodIDFK, amount, mysql_user, timestamp)
    VALUES ('DELETE', OLD.wagonID, OLD.trainIDFK, OLD.goodIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
