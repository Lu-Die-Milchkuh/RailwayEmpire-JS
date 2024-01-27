USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyTrain;

CREATE PROCEDURE sp_buyTrain(IN p_jsonData JSON)
sp:BEGIN
    DECLARE v_userID INT;
    DECLARE v_stationID INT;
    DECLARE v_cost FLOAT;
    DECLARE v_funds FLOAT;
    DECLARE temp_OwnerID INT;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));
    SET v_stationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.stationID'));

    IF NOT EXISTS(SELECT * FROM Station WHERE Station.stationID = v_stationID) THEN
        SELECT JSON_OBJECT(
               'code', 404,
               'message', 'Station does not exist',
               'data', null
       ) as output;
        LEAVE sp;
    END IF;

    SELECT Asset.userIDFK INTO temp_OwnerID FROM Asset INNER JOIN Station ON Asset.assetID = Station.assetIDFK WHERE Station.stationID = v_stationID;

    IF temp_OwnerID != v_userID THEN
        SELECT JSON_OBJECT(
               'code', 401,
               'message', 'You do not own this station',
               'data', null
       ) as output;
        LEAVE sp;
    END IF;

    INSERT INTO Train(stationIDFK) VALUE (v_stationID);

    SELECT cost INTO v_cost FROM Station WHERE stationID = v_stationID;
    SELECT funds INTO v_funds FROM User WHERE userID = v_userID;

    IF v_funds < v_cost THEN
        SELECT JSON_OBJECT(
               'code', 402,
               'message', 'Insufficient funds',
               'data', null
       ) as output;
        LEAVE sp;
    END IF;

    UPDATE User SET funds = v_funds - v_cost WHERE userID = v_userID;

    SELECT JSON_OBJECT(
               'code', 200,
               'message', null,
               'data', null
       ) as output;
END$$

DELIMITER ;