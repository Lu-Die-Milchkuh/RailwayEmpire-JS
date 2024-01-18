USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_createBusiness;

CREATE PROCEDURE sp_createBusiness(IN p_worldID INT)
BEGIN
    DECLARE v_assetID INT;
    DECLARE v_distance INT;
    DECLARE v_businessType INT;
    DECLARE v_businessCount INT;

    -- Loop to create 30 businesses
    SET v_businessCount = 0;
    WHILE v_businessCount < 30
        DO
            REPEAT
                SET @x = FLOOR(RAND() * 1000);
                SET @y = FLOOR(RAND() * 1000);
                SET @point = POINT(@x, @y);

                SELECT assetID, ST_Distance(Point(@x, @y), position)
                INTO v_assetID, v_distance
                FROM Asset
                ORDER BY ST_Distance(Point(@x, @y), position)
                LIMIT 1;

            UNTIL v_assetID IS NULL OR v_distance >= 50 END REPEAT;

            -- Assign business type in a circular manner
            SET v_businessType = (v_businessCount % 6) + 1;

            -- Insert business into the Asset table with a specific type
            INSERT INTO Asset (name, type, population, position, level, cost, costPerDay, worldIDFK)
            VALUES ('Unnamed Business',
                    CASE v_businessType
                        WHEN 1 THEN 'RANCH'
                        WHEN 2 THEN 'FIELD'
                        WHEN 3 THEN 'FARM'
                        WHEN 4 THEN 'LUMBERYARD'
                        WHEN 5 THEN 'PLANTATION'
                        ELSE 'MINE'
                        END,
                    0, @point, 1, 250000, 500, p_worldID);

            SET v_businessCount = v_businessCount + 1;
        END WHILE;

END$$

DELIMITER ;

