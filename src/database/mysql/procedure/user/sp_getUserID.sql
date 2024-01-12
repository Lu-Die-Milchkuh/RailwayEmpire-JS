USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getUserID;

CREATE PROCEDURE sp_getUserID(IN p_token VARCHAR(512))
BEGIN
    SELECT userIDFK as userID FROM Token WHERE token = p_token;
END//

DELIMITER ;
