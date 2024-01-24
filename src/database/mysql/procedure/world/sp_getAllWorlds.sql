USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_getAllWorlds;

CREATE PROCEDURE sp_getAllWorlds()
sp:BEGIN

    DECLARE v_data JSON;

    IF NOT EXISTS(SELECT  * FROM World)THEN
        SELECT JSON_OBJECT(
               'code', 404,
               'message', 'No Worlds found!',
               'data', null
               ) as output;
        LEAVE sp;
    END IF;

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
                   ) INTO v_data
                   FROM World;

     SELECT JSON_OBJECT(
                       'code', 200,
                       'message', null,
                       'data', v_data
               ) as output;

END$$

DELIMITER ;

CALL sp_getAllWorlds();
