USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAssetCost;

CREATE PROCEDURE sp_getAssetCost(IN p_assetId INT)
BEGIN
    SELECT cost FROM Asset WHERE assetID = p_assetId;
END$$

DELIMITER ;

