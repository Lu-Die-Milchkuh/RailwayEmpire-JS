USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_createWorld;

CREATE PROCEDURE sp_createWorld(OUT worldId INT) BEGIN
        INSERT INTO World() VALUE ();
        SELECT LAST_INSERT_ID() INTO worldId FROM World;
END $$