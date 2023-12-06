USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS "sp_buyTown";

CREATE PROCEDURE "sp_buyTown"(IN jsonData JSON)
BEGIN
    DECLARE v_userID INT;
    DECLARE v_townID INT;
    DECLARE v_token VARCHAR(512);
    DECLARE v_townCost FLOAT;
    DECLARE v_funds FLOAT;
    DECLARE v_name VARCHAR(255);

    IF NOT (JSON_VALID(jsonData)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SET v_token = JSON_EXTRACT(jsonData, '$.token');
    SET v_townID = JSON_EXTRACT(jsonData, '$.townID');
    SET v_name = JSON_EXTRACT(jsonData,'$.name');

    SELECT userIDFK INTO v_userID FROM Token WHERE token = v_token;
    SELECT funds INTO v_funds FROM User WHERE userID = v_userID;
    SELECT cost INTO v_townCost FROM Asset WHERE assetID = v_townID;

    IF ((v_funds - v_townCost) < 0) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    UPDATE User SET funds = (v_funds - v_townCost) WHERE userID = v_userID;
    UPDATE Asset SET userIDFK = v_userID WHERE assetID = v_townID;

    IF (v_name NOT NULL) THEN
        UPDATE Asset SET name = v_name WHERE assetID = v_townID;
    END IF;

    SELECT JSON_OBJECT(
                   'assetID', a.assetID,
                   'name', a.name,
                   'owner', u.username,
                   'position', a.position,
                   'cost', a.cost
           ) AS town
    FROM Asset a
             JOIN User u ON a.userIDFK = u.userID
    WHERE a.assetID = v_townID;

END$$
