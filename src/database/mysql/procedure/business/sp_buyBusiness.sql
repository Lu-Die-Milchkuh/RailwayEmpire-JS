USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyBusiness;

CREATE PROCEDURE sp_buyBusiness(in jsonData JSON)
BEGIN
    DECLARE v_funds FLOAT;
    DECLARE v_token VARCHAR(512);
    DECLARE v_type ENUM ('RANCH', 'FIELD', 'FARM', 'LUMBERYARD','PLANTATION','MINE');
    DECLARE v_userID INT;
    DECLARE v_position POINT;
    DECLARE v_cost FLOAT DEFAULT 250000;
    DECLARE v_assetID INT;

    SET v_position = JSON_EXTRACT(jsonData, '$.position');
    SET v_type = JSON_EXTRACT(jsonData, '$.type');
    SET v_token = JSON_EXTRACT(jsonData, '$.token');

    SELECT userIDFK INTO v_userID FROM Token WHERE token = v_token;
    SELECT funds INTO v_funds FROM user WHERE userID = v_userID;
    SELECT assetID INTO v_assetID FROM Asset WHERE position = v_position;

    IF v_funds < v_cost THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    IF v_assetID IS NOT NULL THEN
        -- IF an Asset already exists at the position, check if its owned by someone
        IF EXISTS (SELECT * FROM Asset WHERE position = v_position AND userIDFK IS NOT NULL) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Asset already owned';
        ELSE
            -- Update the existing asset to be owned by the user
            UPDATE Asset SET userIDFK = v_userID WHERE assetID = v_assetID;
            UPDATE User SET funds = v_funds - v_cost WHERE userID = v_userID;
        END IF;
    ELSE
        -- Create a new asset
        INSERT INTO Asset (position, type, userIDFK) VALUES (v_position, v_type, v_userID);
        UPDATE User SET funds = v_funds - v_cost WHERE userID = v_userID;
    END IF;

END$$

DELIMITER ;