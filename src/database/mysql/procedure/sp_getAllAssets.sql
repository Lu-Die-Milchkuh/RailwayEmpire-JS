USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllAssets;

CREATE PROCEDURE sp_getAllAssets(IN token VARCHAR(512))
BEGIN
    DECLARE v_userID INT;
    DECLARE v_worldID INT;

    SELECT userID
    INTO v_userID
    FROM User
             INNER JOIN Token ON User.userID = Token.userIDFK
    WHERE Token.token = token;

    SELECT worldIDFK INTO v_worldID FROM User WHERE userID = v_userID;

    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'assetID', assetID,
                           'type', type,
                           'population', population,
                           'position', JSON_OBJECT(
                                   'x', ST_X(position),
                                   'y', ST_Y(position)
                                       ),
                           'level', level,
                           'cost', cost,
                           'costPerDay', costPerDay,
                           'userID', userIDFK
                   )
           ) AS Assets
    FROM Asset;

END$$

DELIMITER ;
