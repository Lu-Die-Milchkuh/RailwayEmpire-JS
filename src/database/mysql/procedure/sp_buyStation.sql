USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyStation;

CREATE PROCEDURE sp_buyStation(IN jsonData JSON)
BEGIN
    DECLARE v_assetID INT;
    DECLARE v_token VARCHAR(512);
    DECLARE v_funds FLOAT;
    DECLARE v_userID INT;
    DECLARE v_cost FLOAT DEFAULT 100000;

    SET v_assetID = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.assetID'));
    SET v_token = JSON_UNQUOTE(JSON_EXTRACT(jsonData, '$.token'));
    SET v_userID = (SELECT userIDFK FROM Token WHERE token = v_token);
    SET v_funds = (SELECT funds FROM User WHERE userID = v_userID);

    IF v_funds < v_cost
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    UPDATE User SET funds = v_funds - v_cost WHERE userID = v_userID;
    INSERT INTO Station (assetIDFK) VALUES (v_assetID);

END$$

DELIMITER ;
