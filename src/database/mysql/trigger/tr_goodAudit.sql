USE Railway;

DROP TRIGGER IF EXISTS Good_Audit_Update_Trigger;
DROP TRIGGER IF EXISTS Good_Audit_Delete_Trigger;

-- Update
DELIMITER $$

CREATE TRIGGER Good_Audit_Update_Trigger AFTER UPDATE ON Good
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Good_Audit (action, goodID, type, amount, price, mysql_user, timestamp)
    VALUES ('UPDATE', OLD.goodID, OLD.type, OLD.amount, OLD.price, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;

-- Delete
DELIMITER $$

CREATE TRIGGER Good_Audit_Delete_Trigger AFTER DELETE ON Good
FOR EACH ROW
BEGIN
    INSERT INTO Railway_Audit.Good_Audit (action, goodID, type, amount, price, mysql_user, timestamp)
    VALUES ('DELETE', OLD.goodID, OLD.type, OLD.amount, OLD.price, CURRENT_USER(), CURRENT_TIMESTAMP());
END$$

DELIMITER ;
