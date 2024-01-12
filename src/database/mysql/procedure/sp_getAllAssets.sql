USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllAssets;

CREATE PROCEDURE sp_getAllAssets(IN p_worldID INT)
BEGIN

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
    FROM Asset WHERE worldIDFK = p_worldID;

END$$

DELIMITER ;

CALL sp_getAllAssets(35);

