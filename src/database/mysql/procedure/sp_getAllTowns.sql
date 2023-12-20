USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllTowns;

CREATE PROCEDURE sp_getAllTowns()
BEGIN
    SELECT JSON_ARRAYAGG(JSON_OBJECT('assetID', assetID, 'name', name, 'owner', userIDFK, 'level', level)) AS Towns
    FROM Asset
    WHERE type = 'TOWN';
END$$