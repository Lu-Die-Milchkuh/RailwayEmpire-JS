USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getUserFunds;

CREATE PROCEDURE sp_getUserFunds(IN p_token VARCHAR(512))
BEGIN
    DECLARE v_userID INT;
    SELECT userIDFK INTO v_userID FROM Token WHERE token = p_token;
    SELECT funds as Funds FROM User WHERE userID = v_userID;
END$$