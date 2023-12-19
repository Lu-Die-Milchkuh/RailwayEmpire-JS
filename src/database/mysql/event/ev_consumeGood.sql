USE Railway;

DELIMITER $$

DROP EVENT IF EXISTS ev_consumeGood;

-- Assets like Town,Business and Industries consume Goods every day
CREATE EVENT ev_consumeGood ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP DO
BEGIN

END$$

DELIMITER ;