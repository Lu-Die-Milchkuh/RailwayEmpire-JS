USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyTrain;

CREATE PROCEDURE sp_buyTrain(IN p_jsonData JSON)
BEGIN
    DECLARE v_userID INT;
    DECLARE v_stationID INT;
    DECLARE v_cost FLOAT;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));
    SET v_stationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.stationID'));

    INSERT INTO Train(stationIDFK) VALUE (v_stationID);

    SELECT cost INTO v_cost FROM Station WHERE stationID = v_stationID;

    UPDATE User SET funds = funds - v_cost WHERE userID = v_userID;
END$$

DELIMITER ;