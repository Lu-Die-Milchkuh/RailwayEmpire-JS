USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getTownByID;

CREATE PROCEDURE sp_getTownByID(IN townID INT)
BEGIN

    SELECT JSON_OBJECT('assetID', assetID,
                       'type', type,
                       'name', name,
                       'population', population,
                       'position', JSON_OBJECT(
                               'x', ST_X(position),
                               'y', ST_Y(position)
                                   ),
                       'level', level,
                       'cost', cost,
                       'costPerDay', costPerDay,
                       'worldID', worldIDFK,
                       'userID', userIDFK
           ) as Town
    FROM Asset
    WHERE assetID = townID
      AND type = 'Town';
END$$

DELIMITER ;

CALL sp_getTownByID(1012);
