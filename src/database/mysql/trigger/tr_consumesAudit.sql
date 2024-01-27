USE Railway;

DROP TRIGGER IF EXISTS Consumes_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Consumes_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Consumes_Audit_Update_Trigger AFTER UPDATE ON Consumes
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Consumes_Audit (action, goodIDFK, industryIDFK, assetIDFK, amount, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.goodIDFK, OLD.industryIDFK, OLD.assetIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Consumes_Audit_Delete_Trigger AFTER DELETE ON Consumes
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Consumes_Audit (action, goodIDFK, industryIDFK, assetIDFK, amount, mysql_user, timestamp)
    VALUES ('DELETE', OLD.goodIDFK, OLD.industryIDFK, OLD.assetIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
