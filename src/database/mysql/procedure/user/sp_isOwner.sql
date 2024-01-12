USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_isOwner;

CREATE PROCEDURE sp_isOwner(IN p_token VARCHAR(512), IN p_assetID INT)
BEGIN
    DECLARE v_userID INT;

    SELECT userIDFK FROM Token WHERE token = p_token INTO v_userID;

    SELECT JSON_OBJECT(
                   'assetID', Asset.assetID
           ) as Asset
    FROM Asset
    WHERE userIDFK = v_userID
      AND assetID = p_assetID;

END$$