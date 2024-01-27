USE Railway;

DELIMITER //

USE Railway;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_registerUserTest;

CREATE PROCEDURE sp_registerUserTest(IN p_jsonData JSON, OUT output JSON)
sp:
BEGIN

    DECLARE v_username VARCHAR(255);
    DECLARE v_password VARCHAR(255);
    DECLARE v_worldID INT;
    DECLARE v_schema JSON;
    DECLARE v_data JSON;

    SET v_schema = JSON_OBJECT(
            'username', 'string',
            'password', 'string'
            );

    IF NOT JSON_VALID(p_jsonData) OR NOT JSON_SCHEMA_VALID(v_schema, p_jsonData) THEN
        SELECT JSON_OBJECT(
                       'code', 400,
                       'message', 'Invalid JSON',
                       'data', null
               )
        into output;
        LEAVE sp;
    END IF;

    SET v_username = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.username'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(p_jsonData, '$.password'));

    IF v_username IS NULL OR v_password IS NULL THEN
        SELECT JSON_OBJECT(
                       'code', 400,
                       'message', 'Invalid JSON: Missing fields',
                       'data', null
               )
        into output;
        LEAVE sp;
    END IF;

    IF EXISTS (SELECT username FROM User WHERE username = v_username) THEN
        SELECT JSON_OBJECT(
                       'code', 400,
                       'message', 'Username already taken',
                       'data', null
               )
        into output;
        LEAVE sp;
    END IF;

    -- Insert the new user into the User table with the worldID
    INSERT INTO Railway.User (username, password, joinDate, worldIDFK)
    VALUES (v_username, v_password, CURRENT_TIMESTAMP, v_worldID);

    SELECT JSON_OBJECT(
                   'worldID', v_worldID,
                   'userID', LAST_INSERT_ID()
           )
    INTO v_data;

    SELECT JSON_OBJECT(
                   'code', 200,
                   'message', 'User registered successfully',
                   'data', v_data
           )
    into output;

END$$


START TRANSACTION;

SET @user = '{"username": "Foo", "password": "Bar"}';
SET @testResult = '';

/*
Test Case: TC01
    Description: The IN JSON is valid and the username is not taken
*/
CALL sp_registerUserTest(@user, @output);
SET @testResult =
        CONCAT(@testResult, 'TC01: ', IF(@output LIKE '%"code": 200%', 'Pass', CONCAT('Fail(', @output, ')')));

/*
Test Case: TC02
    Description: The IN JSON is valid and the username is taken
 */
CALL sp_registerUserTest(@user, @output);
SET @testResult =
        CONCAT(@testResult, ' TC02: ', IF(@output LIKE '%"code": 200%', 'Pass', CONCAT('Fail(', @output, ')')));

/*
Test Case: TC03
    Description: The IN JSON is invalid (Missing the password field)
 */

SET @user = '{"username": "foo"}';

CALL sp_registerUserTest(@user, @output);
SET @testResult =
        CONCAT(@testResult, ' TC03: ', IF(@output LIKE '%"code": 200%', 'Pass', CONCAT('Fail(', @output, ')')));

SELECT @testResult;

ROLLBACK;

