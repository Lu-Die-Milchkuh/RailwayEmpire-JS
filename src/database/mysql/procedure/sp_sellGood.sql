USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_sellGood;

CREATE PROCEDURE sp_sellGood(IN jsonData JSON)
BEGIN
    DECLARE v_type ENUM ('MAIL','PASSENGER','FRUIT','WHEAT','CATTLE','GRAIN','WOOD','MILK','PLANKS','LEATHER','WOOL','ORE','TOOLS','GEMS','BEVERAGE','MEAT','BREAD','CHEESE','FURNITURE','CLOTHING','METALS','JEWELLERY');
    DECLARE v_amount INT;
    DECLARE v_price INT;
    DECLARE v_goodID INT;
    DECLARE v_assetID INT;
    DECLARE v_userID INT;
    DECLARE v_goodStock INT;

    SET v_type = JSON_EXTRACT(jsonData, '$.type');
    SET v_amount = JSON_EXTRACT(jsonData, '$.amount');
    SET v_assetID = JSON_EXTRACT(jsonData, '$.assetID');

    SET v_userID = (SELECT userIDFK FROM Asset WHERE assetID = v_assetID);
    SET v_goodID = (SELECT goodID FROM Good WHERE type = v_type);
    SET v_goodStock = (SELECT amount FROM Stockpile WHERE goodIDFK = v_goodID AND assetIDFK = v_assetID);
    SET v_price = (SELECT price FROM Good WHERE goodID = v_goodID);

    IF v_goodStock < v_amount THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Not enough goods in stock';
    ELSE
        SET v_price = (SELECT price FROM Good WHERE goodID = v_goodID);
        UPDATE Stockpile SET amount = amount - v_amount WHERE goodIDFK = v_goodID AND assetIDFK = v_assetID;
        UPDATE User SET funds = funds + v_amount * v_price WHERE userID = v_userID;
    END IF;

END$$

DELIMITER ;