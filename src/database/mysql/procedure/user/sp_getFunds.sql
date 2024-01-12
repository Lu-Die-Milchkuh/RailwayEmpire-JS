USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getFunds;

CREATE PROCEDURE sp_getFunds(IN p_userID INT)
BEGIN
    SELECT funds as Funds FROM User WHERE userID = p_userID;
END//

DELIMITER ;


