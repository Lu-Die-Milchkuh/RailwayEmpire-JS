USE Railway;

DELIMITER $$

DROP EVENT IF EXISTS ev_produceGood;

-- Assets like Towns,Business and Industries produce goods every day IF their needs are met
CREATE EVENT ev_produceGood ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP DO
BEGIN

END$$

DELIMITER ;