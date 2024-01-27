DROP DATABASE IF EXISTS Railway_Audit;

CREATE DATABASE Railway_Audit;

USE Railway_Audit;

CREATE TABLE World_Audit (
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    worldID INT,
    creationDate TIMESTAMP,
    user_action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE User_Audit (
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    userID INT,
    username VARCHAR(255),
    password VARCHAR(255),
    funds FLOAT,
    joinDate TIMESTAMP,
    worldIDFK INT,
    user_action ENUM('UPDATE', 'DELETE') NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Token_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    tokenID  INT,
    userIDFK INT          NOT NULL,
    token    VARCHAR(512) NOT NULL,
    created  DATETIME DEFAULT CURRENT_TIMESTAMP,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Good_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    goodID INT,
    type   ENUM ('MAIL','PASSENGER','FRUIT','WHEAT','CATTLE','GRAIN','WOOD','MILK','PLANKS','LEATHER','WOOL','ORE','TOOLS','GEMS','BEVERAGE','MEAT','BREAD','CHEESE','FURNITURE','CLOTHING','METALS','JEWELLERY') NOT NULL,
    amount INT                                                                                                                                                                                                    NOT NULL,
    price  FLOAT,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Asset_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    assetID    INT,
    type       ENUM ('TOWN', 'RANCH', 'FIELD', 'FARM', 'LUMBERYARD','PLANTATION','MINE') NOT NULL,
    name       VARCHAR(255) DEFAULT 'Unnamed',
    population INT          DEFAULT 0,
    position   POINT                                                                     NOT NULL,
    level      INT          DEFAULT 1,
    cost       FLOAT                                                                     NOT NULL,
    costPerDay FLOAT                                                                     NOT NULL,
    worldIDFK  INT,
    userIDFK   INT,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);



CREATE TABLE
    Station_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    stationID  INT,
    assetIDFK  INT NOT NULL,
    cost       FLOAT DEFAULT 100000,
    costPerDay FLOAT DEFAULT (1000.0 / 7.0),
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);


CREATE TABLE
    Track_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    trackID      INT,
    stationID1FK INT NOT NULL,
    stationID2FK INT NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Industry_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    industryID INT,
    type       ENUM (
        'BREWERY', 'BUTCHER', 'BAKERY', 'SAWMILL', 'CHEESEMAKER', 'CARPENTER','TAILOR',
        'SMELTER', 'SMITHY', 'JEWELER'
        )          NOT NULL,
    assetIDFK  INT NOT NULL,
    cost       FLOAT DEFAULT 500000,
    costPerDay FLOAT DEFAULT 500,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Consumes_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    goodIDFK     INT NOT NULL,
    industryIDFK INT,
    assetIDFK    INT,
    amount       INT NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Produces_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    goodIDFK     INT NOT NULL,
    industryIDFK INT,
    assetIDFK    INT,
    amount       INT NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Stockpile_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    assetIDFK INT NOT NULL,
    goodIDFK  INT NOT NULL,
    amount    INT NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Needs_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    needsID   INT,
    assetIDFK INT NOT NULL,
    goodIDFK  INT NOT NULL,
    amount    INT NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Train_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    trainID     INT,
    stationIDFK INT NOT NULL,
    cost        INT DEFAULT 50000,
    costPerDay  INT DEFAULT 500,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Wagon_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    wagonID   INT,
    trainIDFK INT NOT NULL,
    goodIDFK  INT NOT NULL,
    amount    INT NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE
    Route_Audit
(
    auditID INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('UPDATE', 'DELETE') NOT NULL,
    routeID     INT,
    trainIDFK   INT NOT NULL,
    stationIDFK INT NOT NULL,
    daysLeft    INT NOT NULL,
    mysql_user VARCHAR(255),
    timestamp TIMESTAMP
);