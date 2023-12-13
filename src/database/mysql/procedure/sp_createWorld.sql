USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_createWorld;

CREATE PROCEDURE sp_createWorld(OUT p_worldId INT)
BEGIN
    DECLARE v_worldId INT;
    INSERT INTO World() VALUE ();

    SET @numberOfTowns = 15;
    SET @numberOfBusiness = 30;

    SET @i = 0;

    SELECT MAX(worldId) INTO v_worldId FROM World;

    WHILE @i < @numberOfTowns DO
        CALL sp_createTown(v_worldId);
        SET @i = @i + 1;
    END WHILE;

    SET @i = 0;

    WHILE @i < @numberOfBusiness DO
        CALL sp_createBusiness(v_worldId);
        SET @i = @i + 1;
    END WHILE;

    SELECT MAX(worldId) INTO p_worldId FROM World;
END $$

DELIMITER ;

CALL sp_createWorld(@worldId);

