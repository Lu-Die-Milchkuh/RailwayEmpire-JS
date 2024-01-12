DELIMITER $$

DROP PROCEDURE IF EXISTS sp_gameOver;

CREATE PROCEDURE sp_gameOver(IN p_userID INT)
BEGIN
    DECLARE v_assetID INT;
    DECLARE v_industryID INT;
    DECLARE v_money FLOAT DEFAULT 0;
    DECLARE done TINYINT DEFAULT FALSE;

    -- Cursor for fetching assets and industries belonging to the user
    DECLARE assetCursor CURSOR FOR
        SELECT assetID FROM Asset WHERE userIDFK = p_userID;

    DECLARE industryCursor CURSOR FOR
        SELECT industryID FROM Industry WHERE assetIDFK IN (SELECT assetID FROM Asset WHERE userIDFK = p_userID);

    -- Declare handler for NOT FOUND condition
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Start transaction
    START TRANSACTION;

    -- Sell assets
    OPEN assetCursor;
    assetLoop:
    LOOP
        FETCH assetCursor INTO v_assetID;
        IF done THEN
            LEAVE assetLoop;
        END IF;

        -- Perform actions to sell the asset (update funds, etc.)
        SET v_money = (SELECT cost FROM Asset WHERE assetID = v_assetID);

        -- Update the user's funds
        UPDATE User SET funds = funds + v_money WHERE userID = p_userID;

        -- Delete all Stations belonging to the Asset
        DELETE FROM Station WHERE assetIDFK = v_assetID;
        DELETE FROM Consumes WHERE assetIDFK = v_assetID;
        DELETE FROM Produces WHERE assetIDFK = v_assetID;
        DELETE FROM Stockpile WHERE assetIDFK = v_assetID;
        DELETE FROM Needs WHERE assetIDFK = v_assetID;

        -- Don't delete the Asset, just clear up the owner, so it can be sold again
        UPDATE Asset SET userIDFK = NULL WHERE assetID = v_assetID;
    END LOOP;
    CLOSE assetCursor;

    -- Sell industries
    OPEN industryCursor;
    industryLoop:
    LOOP
        FETCH industryCursor INTO v_industryID;
        IF done THEN
            LEAVE industryLoop;
        END IF;

        -- Perform actions to sell the industry (update funds, etc.)
        SET v_money = (SELECT cost FROM Industry WHERE industryID = v_industryID);

        -- Update the user's funds
        UPDATE User SET funds = funds + v_money WHERE userID = p_userID;

        -- Delete the industry
        DELETE FROM Industry WHERE industryID = v_industryID;
    END LOOP;
    CLOSE industryCursor;

    -- Commit the transaction
    COMMIT;
END $$

DELIMITER ;
