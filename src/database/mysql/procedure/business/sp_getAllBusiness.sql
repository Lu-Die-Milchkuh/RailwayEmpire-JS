USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllBusiness;


CREATE PROCEDURE sp_getAllBusiness(IN p_worldID INT)
BEGIN
    SELECT JSON_ARRAYAGG(JSON_OBJECT('assetID', assetID, 'name', name, 'owner', userIDFK, 'level', level, 'worldID',
                                     worldIDFK)) AS Business
    FROM Asset
    WHERE type != 'TOWN' AND worldIDFK = p_worldID;

END$$

DELIMITER ;

-- CALL sp_getBusiness();
