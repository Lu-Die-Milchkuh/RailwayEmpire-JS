USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getIndustryForTown;


CREATE PROCEDURE sp_getIndustryForTown(IN p_assetID INT)
BEGIN
    SELECT JSON_ARRAYAGG(JSON_OBJECT('industryID', Industry.industryID) FROM Industry WHERE
                         assetIDFK = p_assetID) AS Industries
    FROM Industry;
END$$

DELIMITER ;
