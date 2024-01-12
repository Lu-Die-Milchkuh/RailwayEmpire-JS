USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_createTown;

CREATE PROCEDURE sp_createTown(IN p_worldID INT)
BEGIN
    DECLARE v_assetID INT;
    DECLARE v_distance INT;

    REPEAT
        SET @x = FLOOR(RAND() * 1000);
        SET @y = FLOOR(RAND() * 1000);
        SET @point = POINT(@x, @y);

        SELECT assetID, ST_Distance(Point(@x, @y), position) INTO v_assetID, v_distance FROM Asset ORDER BY ST_Distance(Point(@x, @y), position) LIMIT 1;

    UNTIL v_assetID IS NULL OR v_distance >= 50 END REPEAT;

    INSERT INTO Asset (name, type, population, position, level, cost, costPerDay, worldIDFK)
    VALUES ('Unnamed', 'TOWN', 500, @point, 1, 250000, 0, p_worldID);

END$$

DELIMITER ;
