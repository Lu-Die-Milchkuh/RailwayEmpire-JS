USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllIndustries;

CREATE PROCEDURE sp_getAllIndustries()
BEGIN
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'industryID', industryID,
            'type', type,
            'assetIDFK', assetIDFK
           )) as Industries FROM Industry;
END$$

DELIMITER ;

CALL sp_getAllIndustries();


