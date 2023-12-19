USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyGood;

CREATE PROCEDURE sp_buyGood(IN jsonData JSON)
BEGIN

    DECLARE v_token VARCHAR(512);
    DECLARE v_type ENUM ('MAIL','PASSENGER','FRUIT','WHEAT','CATTLE','GRAIN','WOOD','MILK','PLANKS','LEATHER','WOOL','ORE','TOOLS','GEMS','BEVERAGE','MEAT','BREAD','CHEESE','FURNITURE','CLOTHING','METALS','JEWELLERY');
    DECLARE v_amount INT;
    DECLARE v_price INT;
    DECLARE v_userID INT;
    DECLARE v_funds FLOAT;
    DECLARE v_assetID INT;
    DECLARE v_goodID INT;

    IF NOT (JSON_VALID(jsonData)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SET v_assetID = JSON_EXTRACT(jsonData, '$.assetID');
    SET v_type = JSON_EXTRACT(jsonData, '$.type');
    SET v_amount = JSON_EXTRACT(jsonData, '$.amount');
    SET v_token = JSON_EXTRACT(jsonData, '$.token');
    SET v_userID = (SELECT userIDFK FROM Asset WHERE assetID = v_assetID);
    SET v_price = (SELECT price FROM Good WHERE type = v_type);
    SET v_funds = (SELECT funds FROM User WHERE userID = v_userID);
    SET v_goodID = (SELECT goodID FROM Good WHERE type = v_type);

    IF (v_amount < 0) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid amount';
    END IF;

    IF (v_funds < v_price * v_amount) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    UPDATE User SET funds = funds - v_price * v_amount WHERE userID = v_userID;
    UPDATE Stockpile SET amount = amount + v_amount WHERE assetIDFK = v_assetID AND goodIDFK = v_goodID;

END$$

DELIMITER ;