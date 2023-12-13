USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_createBusiness;

CREATE PROCEDURE sp_createBusiness(IN p_worldID INT)
sp_createBusiness:
BEGIN
    DECLARE v_assetID INT;

    SET @x = FLOOR(RAND() * 1000);
    SET @y = FLOOR(RAND() * 1000);
    SET @point = Point(@x, @y);

    SELECT assetID INTO v_assetID FROM Asset WHERE position = @point;

    -- Oh yeah, this is a recursive procedure
    IF v_assetID IS NOT NULL THEN
        CALL sp_createBusiness(p_worldID);
        LEAVE sp_createBusiness;
    END IF;

    INSERT INTO Asset (name, type, population, position, level, cost, costPerDay, worldIDFK)
    VALUES ('Unnamed', 'TOWN', 500, @point, 1, 250000, 0, p_worldID);

END$$

DELIMITER ;