USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getProfile;


CREATE PROCEDURE sp_getProfile(IN p_jsonData JSON)
sp:
BEGIN
    DECLARE v_data JSON;
    DECLARE v_schema JSON;

    DECLARE v_userId INT;

    SET v_schema = JSON_OBJECT(
            'userID', 'integer'
                   );

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SELECT JSON_OBJECT('status', 400, 'message', 'Invalid JSON') AS response;
        LEAVE sp;
    END IF;

    SET v_userId = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.userID'));

    IF NOT EXISTS(SELECT * FROM User WHERE userID = v_userId) THEN
        SELECT JSON_OBJECT(
                       'code', 404,
                       'message', 'User does not exist',
                       'data', null
               ) AS output;
        LEAVE sp;
    END IF;

    SELECT JSON_OBJECT(
                   'userID', userID,
                   'username', username,
                   'funds', funds,
                   'joinDate', joinDate,
                   'worldID', worldIDFK,
                   'assets', (SELECT JSON_ARRAYAGG(
                                             JSON_OBJECT(
                                                     'name', name,
                                                     'assetID', assetID,
                                                     'type', type
                                             ))
                              FROM Asset
                              WHERE userIDFK = v_userId))
    FROM User
    WHERE userID = v_userId
    INTO v_data;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', null,
                   'data', v_data) AS output;

end//

CALL sp_getProfile('{"userID": 7}');
