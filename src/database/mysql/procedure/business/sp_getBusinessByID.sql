USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getBusinessByID;


CREATE PROCEDURE sp_getBusinessByID(IN p_businessID INT)
BEGIN
    SELECT JSON_OBJECT(
        'businessID', assetID
           ) FROM Asset WHERE type != 'TOWN' AND assetID = p_businessID;
END //
