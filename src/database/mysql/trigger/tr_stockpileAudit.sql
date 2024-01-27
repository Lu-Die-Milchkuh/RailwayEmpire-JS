USE Railway;

DROP TRIGGER IF EXISTS Stockpile_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Stockpile_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Stockpile_Audit_Update_Trigger AFTER UPDATE ON Stockpile
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Stockpile_Audit (action, assetIDFK, goodIDFK, amount, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.assetIDFK, OLD.goodIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Stockpile_Audit_Delete_Trigger AFTER DELETE ON Stockpile
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Stockpile_Audit (action, assetIDFK, goodIDFK, amount, mysql_user, timestamp)
    VALUES ('DELETE', OLD.assetIDFK, OLD.goodIDFK, OLD.amount, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
