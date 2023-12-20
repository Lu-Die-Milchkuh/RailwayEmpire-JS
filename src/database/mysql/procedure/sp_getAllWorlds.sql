USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllWorlds;

CREATE PROCEDURE sp_getAllWorlds()
BEGIN

    DECLARE v_worlds JSON;

    -- Select world information and players for all worlds as JSON array
    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'worldID', worldID,
                           'creationDate', creationDate,
                           'players', (SELECT JSON_ARRAYAGG(
                                                      JSON_OBJECT('userID', userID, 'username', username, 'funds',
                                                                  funds, 'joinDate', joinDate)
                                              )
                                       FROM User
                                       WHERE worldIDFK = World.worldID),
                           'assets', (SELECT JSON_ARRAYAGG(
                                                     JSON_OBJECT(
                                                             'assetID', assetID,
                                                             'type', type,
                                                             'population', population,
                                                             'position', JSON_OBJECT(
                                                                     'x', ST_X(position),
                                                                     'y', ST_Y(position)
                                                                         ),
                                                             'level', level,
                                                             'cost', cost,
                                                             'costPerDay', costPerDay,
                                                             'userID', userIDFK
                                                     )
                                             )
                                      FROM Asset))
                   ) INTO v_worlds
                   FROM World;

    -- Return the array of worlds with players
    SELECT v_worlds as Worlds;

END$$

DELIMITER ;
