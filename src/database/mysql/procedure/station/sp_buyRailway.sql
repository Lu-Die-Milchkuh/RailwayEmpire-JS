USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_buyRailway;

CREATE PROCEDURE sp_buyRailway(IN p_jsonData JSON)
sp:
BEGIN

    DECLARE v_sourceStationID INT;
    DECLARE v_destinationStationID INT;
    DECLARE v_userID INT;
    DECLARE v_schema JSON;
    DECLARE v_assetID INT;
    DECLARE temp_userID INT;
    DECLARE v_distance FLOAT;
    DECLARE v_funds FLOAT;

    SET v_schema = JSON_OBJECT(
            'src', 'integer',
            'dst', 'integer',
            'userID', 'integer'
                   );

    IF NOT (JSON_VALID(p_jsonData)) OR NOT (JSON_SCHEMA_VALID(v_schema, p_jsonData)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid JSON';
    END IF;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));
    SET v_sourceStationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.src'));
    SET v_destinationStationID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.dst'));

    -- Check if the User exists
    IF NOT EXISTS (SELECT * FROM Railway.User WHERE userID = v_userID) THEN
        SELECT JSON_OBJECT('code', 404,
                           'message', 'User does not exist',
                           'data', null) as output;
        LEAVE sp;
    END IF;

    -- Check if the Source Station exists
    IF NOT EXISTS (SELECT * FROM Railway.Station WHERE stationID = v_sourceStationID) THEN
        SELECT JSON_OBJECT('code', 404,
                           'message', 'Source station does not exist',
                           'data', null) as output;
        LEAVE sp;
    END IF;

    -- Check if the Destination Station exists
    IF NOT EXISTS (SELECT * FROM Railway.Station WHERE stationID = v_destinationStationID) THEN
        SELECT JSON_OBJECT('code', 404,
                           'message', 'Destination station does not exist',
                           'data', null) as output;
        LEAVE sp;
    END IF;

    -- Check if the User is the Owner of the Source Station
    IF NOT (v_userID = temp_userID) THEN
        SELECT JSON_OBJECT('code', 401,
                           'message', 'You are not the Owner of the Source Station',
                           'data', null) as output;
        LEAVE sp;
    END IF;

     SELECT funds INTO v_funds FROM User WHERE userID = v_userID;
    SELECT assetIDFK INTO v_assetID FROM Railway.Station WHERE stationID = v_sourceStationID;
    SELECT Asset.userIDFK INTO temp_userID FROM Railway.Asset WHERE assetID = v_assetID;

    CALL sp_getDistance(v_sourceStationID, v_destinationStationID, @distance);

    IF (v_funds < @distance) THEN
        SELECT JSON_OBJECT('code', 402,
                           'message', 'Insufficient funds',
                           'data', null) as output;
        LEAVE sp;
    END IF;

    INSERT INTO Track (stationID1FK, stationID2FK) VALUES (v_sourceStationID, v_destinationStationID);
    -- Cost of a Railway will just be its distance, in the future a better formula can be used
    UPDATE User SET funds = funds - @distance WHERE userID = v_userID;

    SELECT JSON_OBJECT('code', 200,
                       'message', null,
                       'data', null) as output;
END$$
DELIMITER ;