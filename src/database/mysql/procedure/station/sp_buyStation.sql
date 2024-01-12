USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyStation;

CREATE PROCEDURE sp_buyStation(IN p_assetID INT)
BEGIN
    DECLARE v_funds FLOAT;
    DECLARE v_userID INT;
    DECLARE v_cost FLOAT DEFAULT 100000;

    SET v_userID = (SELECT userIDFK FROM Asset WHERE assetID = p_assetID);
    SET v_funds = (SELECT funds FROM User WHERE userID = v_userID);

    IF v_funds < v_cost
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    UPDATE User SET funds = v_funds - v_cost WHERE userID = v_userID;
    INSERT INTO Station (assetIDFK) VALUES (p_assetID);

END$$

DELIMITER ;
