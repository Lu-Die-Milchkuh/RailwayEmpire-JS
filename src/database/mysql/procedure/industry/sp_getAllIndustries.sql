USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllIndustries;

CREATE PROCEDURE sp_getAllIndustries(IN p_townID INT)
BEGIN
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'industryID', industryID,
            'type', type,
            'assetIDFK', assetIDFK
           )) as Industries
    FROM Industry
    WHERE assetIDFK = p_townID;
END$$

DELIMITER ;

-- CALL sp_getAllIndustries();


