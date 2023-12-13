USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyIndustry;

CREATE PROCEDURE sp_buyIndustry(IN jsonData JSON)
BEGIN
    DECLARE v_userID INT;
    DECLARE v_townID INT;
    DECLARE v_funds FLOAT;
    DECLARE v_industryCost FLOAT;
    DECLARE v_token VARCHAR(512);
    DECLARE v_industryType ENUM (
        'BREWERY', 'BUTCHER', 'BAKERY', 'SAWMILL', 'CHEESEMAKER', 'CARPENTER','TAILOR',
        'SMELTER', 'SMITHY', 'JEWELER'
        );

    IF NOT (JSON_VALID(jsonData)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;

    SET v_token = JSON_EXTRACT(jsonData, '$.token');
    SET v_townID = JSON_EXTRACT(jsonData, '$.townID');
    SET v_industryType = JSON_EXTRACT(jsonData, '$.type');

    IF v_token IS NULL OR v_townID IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;

    -- TODO: Check how many Industries the Town can have

    SELECT userIDFK INTO v_userID FROM Token WHERE token = v_token;
    SELECT funds INTO v_funds FROM User WHERE userID = v_userID;
    SELECT cost INTO v_industryCost FROM Industry WHERE assetIDFK = v_townID;

    IF ((v_funds - v_industryCost) < 0) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Not enough funds';
    END IF;

    UPDATE User SET funds = v_funds - v_industryCost WHERE userID = v_userID;


    INSERT INTO Industry (assetIDFK) VALUES (v_townID);


END$$

DELIMITER ;
