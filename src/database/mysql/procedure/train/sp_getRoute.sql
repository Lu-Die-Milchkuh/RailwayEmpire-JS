USE Railway;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_getRoute;

CREATE PROCEDURE sp_getRoute(IN p_trainID INT)
BEGIN
    SELECT routeID as Route FROM Route WHERE trainIDFK = p_trainID;
END //

DELIMITER ;
