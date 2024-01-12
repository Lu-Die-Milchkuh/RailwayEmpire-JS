USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllTowns;

CREATE PROCEDURE sp_getAllTowns(IN p_worldID INT)
BEGIN
    SELECT JSON_ARRAYAGG(JSON_OBJECT('assetID', assetID, 'name', name, 'owner', userIDFK, 'level', level, 'worldID',
                                     worldIDFK)) AS Towns
    FROM Asset
    WHERE type = 'TOWN' AND worldIDFK = p_worldID;
END$$

