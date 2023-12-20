USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_isAssetFree;

CREATE PROCEDURE sp_isAssetFree(p_assetID INT)
BEGIN
    SELECT userIDFK as Owner FROM Asset WHERE assetID = p_assetID;
END$$

DELIMITER ;

