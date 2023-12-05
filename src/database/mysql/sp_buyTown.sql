USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS "sp_buyTown";

CREATE PROCEDURE "sp_buyTown"(IN jsonData JSON) BEGIN
        DECLARE v_userID INT;
        DECLARE v_token VARCHAR(512);
        DECLARE v_townCost FLOAT;
        DECLARE v_funds FLOAT;

        IF NOT(JSON_VALID(jsonData)) THEN
            SIGNAL SQLSTATE '45000'
	        SET MESSAGE_TEXT = 'Invalid JSON';
	    END IF;

        SET v_token = JSON_EXTRACT(jsonData,'$.token');
        SELECT userIDFK INTO v_userID FROM Token WHERE token = v_token;
        SELECT funds INTO v_funds FROM User WHERE userID = v_userID;
        SELECT cost INTO v_townCost FROM Asset WHERE assetID = 0;

        IF (v_funds - v_townCost < 0)THEN
            
        END IF;

END$$