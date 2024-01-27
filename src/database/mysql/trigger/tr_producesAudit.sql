USE Railway;

DROP TRIGGER IF EXISTS Produces_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Produces_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Produces_Audit_Update_Trigger AFTER UPDATE ON Produces
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Produces_Audit (action, goodIDFK, industryIDFK, assetIDFK, amount, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.goodIDFK, OLD.industryIDFK, OLD.assetIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Produces_Audit_Delete_Trigger AFTER DELETE ON Produces
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Produces_Audit (action, goodIDFK, industryIDFK, assetIDFK, amount, mysql_user, timestamp)
    VALUES ('DELETE', OLD.goodIDFK, OLD.industryIDFK, OLD.assetIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
