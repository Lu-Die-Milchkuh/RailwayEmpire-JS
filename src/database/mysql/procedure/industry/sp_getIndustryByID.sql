USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getIndustryByID;

CREATE PROCEDURE sp_getIndustryByID(IN p_id INT)
BEGIN
    SELECT JSON_OBJECT(
                   'industryID', industryID,
                   'type', type
           ) AS Industry
    FROM Industry
    WHERE industryID = p_id;
END$$

DELIMITER $$