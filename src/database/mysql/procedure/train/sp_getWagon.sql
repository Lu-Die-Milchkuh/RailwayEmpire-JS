USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getWagon;

CREATE PROCEDURE sp_getWagon(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE v_userID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = '{
      "userID": "integer"
    }';

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema,p_jsonData) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JSON is not valid';
    END IF;

    SET v_userID = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));


    SELECT JSON_ARRAYAGG(
           JSON_OBJECT(
            'wagonID', w.wagonID,
            'trainIDFK', w.trainIDFK,
            'goodIDFK', w.goodIDFK,
            'amount', w.amount
           )
           ) INTO v_data
    FROM Wagon w
    INNER JOIN Train t ON w.trainIDFK = t.trainID
    INNER JOIN Station s ON t.stationIDFK = s.stationID
    INNER JOIN Asset a ON s.assetIDFK = a.assetID
    WHERE a.userIDFK = v_userID;

    IF v_data IS NULL THEN
        SELECT JSON_OBJECT(
               'code', 404,
                'message', 'No Wagons not found',
                'data', null
                ) as output;

       LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
           'code', 200,
           'message', null,
           'data', v_data
           ) as output;

END//