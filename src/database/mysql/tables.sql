DROP DATABASE IF EXISTS Railway;

CREATE DATABASE IF NOT EXISTS Railway;

USE Railway;

CREATE TABLE
    World
(
    worldID      INT AUTO_INCREMENT PRIMARY KEY,
    creationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE
    User
(
    userID    INT AUTO_INCREMENT PRIMARY KEY,
    username  VARCHAR(255) UNIQUE NOT NULL,
    password  VARCHAR(255)        NOT NULL,
    funds     FLOAT     DEFAULT 100000.0,
    joinDate  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    worldIDFK INT,
    FOREIGN KEY (worldIDFK) REFERENCES World (worldID) ON DELETE CASCADE
);

CREATE TABLE
    Token
(
    tokenID  INT AUTO_INCREMENT PRIMARY KEY,
    userIDFK INT          NOT NULL,
    token    VARCHAR(512) NOT NULL,
    created  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userIDFK) REFERENCES User (userID) ON DELETE CASCADE
);

CREATE TABLE
    Good
(
    goodID INT AUTO_INCREMENT PRIMARY KEY,
    type   ENUM ('MAIL','PASSENGER','FRUIT','WHEAT','CATTLE','GRAIN','WOOD','MILK','PLANKS','LEATHER','WOOL','ORE','TOOLS','GEMS','BEVERAGE','MEAT','BREAD','CHEESE','FURNITURE','CLOTHING','METALS','JEWELLERY') NOT NULL,
    amount INT                                                                                                                                                                                                    NOT NULL,
    price  FLOAT
);

CREATE TABLE
    Asset
(
    assetID    INT AUTO_INCREMENT PRIMARY KEY,
    type       ENUM ('TOWN', 'RANCH', 'FIELD', 'FARM', 'LUMBERYARD','PLANTATION','MINE') NOT NULL,
    name       VARCHAR(255) DEFAULT 'Unnamed',
    population INT          DEFAULT 0,
    position   POINT                                                                     NOT NULL,
    level      INT          DEFAULT 1,
    cost       FLOAT                                                                     NOT NULL,
    costPerDay FLOAT                                                                     NOT NULL,
    worldIDFK  INT,
    userIDFK   INT,
    FOREIGN KEY (worldIDFK) REFERENCES World (worldID) ON DELETE CASCADE,
    FOREIGN KEY (userIDFK) REFERENCES User (userID) ON DELETE CASCADE
);

CREATE TABLE
    Station
(
    stationID  INT AUTO_INCREMENT PRIMARY KEY,
    assetIDFK  INT NOT NULL,
    cost       FLOAT DEFAULT 100000,
    costPerDay FLOAT DEFAULT (1000.0 / 7.0),
    FOREIGN KEY (assetIDFK) REFERENCES Asset (assetID) ON DELETE CASCADE
);

CREATE TABLE
    Track
(
    trackID      INT AUTO_INCREMENT PRIMARY KEY,
    stationID1FK INT NOT NULL,
    stationID2FK INT NOT NULL,
    FOREIGN KEY (stationID1FK) REFERENCES Station (stationID) ON DELETE CASCADE,
    FOREIGN KEY (stationID2FK) REFERENCES Station (stationID) ON DELETE CASCADE
);

CREATE TABLE
    Industry
(
    industryID INT AUTO_INCREMENT PRIMARY KEY,
    type       ENUM (
        'BREWERY', 'BUTCHER', 'BAKERY', 'SAWMILL', 'CHEESEMAKER', 'CARPENTER','TAILOR',
        'SMELTER', 'SMITHY', 'JEWELER'
        )          NOT NULL,
    assetIDFK  INT NOT NULL,
    cost       FLOAT DEFAULT 500000,
    costPerDay FLOAT DEFAULT 500,
    FOREIGN KEY (assetIDFK) REFERENCES Asset (assetID) ON DELETE CASCADE
);

CREATE TABLE
    Consumes
(
    goodIDFK     INT NOT NULL,
    industryIDFK INT,
    assetIDFK    INT,
    amount       INT NOT NULL,
    FOREIGN KEY (goodIDFK) REFERENCES Good (goodID) ON DELETE CASCADE,
    FOREIGN KEY (industryIDFK) REFERENCES Industry (industryID) ON DELETE CASCADE,
    FOREIGN KEY (assetIDFK) REFERENCES Asset (assetID) ON DELETE CASCADE
);

CREATE TABLE
    Produces
(
    goodIDFK     INT NOT NULL,
    industryIDFK INT,
    assetIDFK    INT,
    amount       INT NOT NULL,
    FOREIGN KEY (goodIDFK) REFERENCES Good (goodID) ON DELETE CASCADE,
    FOREIGN KEY (industryIDFK) REFERENCES Industry (industryID) ON DELETE CASCADE,
    FOREIGN KEY (assetIDFK) REFERENCES Asset (assetID) ON DELETE CASCADE
);

CREATE TABLE
    Stockpile
(
    assetIDFK INT NOT NULL,
    goodIDFK  INT NOT NULL,
    amount    INT NOT NULL,
    FOREIGN KEY (assetIDFK) REFERENCES Asset (assetID) ON DELETE CASCADE,
    FOREIGN KEY (goodIDFK) REFERENCES Good (goodID) ON DELETE CASCADE
);

CREATE TABLE
    Needs
(
    needsID   INT AUTO_INCREMENT PRIMARY KEY,
    assetIDFK INT NOT NULL,
    goodIDFK  INT NOT NULL,
    amount    INT NOT NULL,
    FOREIGN KEY (assetIDFK) REFERENCES Asset (assetID) ON DELETE CASCADE,
    FOREIGN KEY (goodIDFK) REFERENCES Good (goodID) ON DELETE CASCADE
);

CREATE TABLE
    Train
(
    trainID     INT AUTO_INCREMENT PRIMARY KEY,
    stationIDFK INT NOT NULL,
    cost        INT DEFAULT 50000,
    costPerDay  INT DEFAULT 500,
    FOREIGN KEY (stationIDFK) REFERENCES Station (stationID) ON DELETE CASCADE
);

CREATE TABLE
    Wagon
(
    wagonID   INT AUTO_INCREMENT PRIMARY KEY,
    trainIDFK INT NOT NULL,
    goodIDFK  INT NOT NULL,
    amount    INT NOT NULL,
    FOREIGN KEY (trainIDFK) REFERENCES Train (trainID) ON DELETE CASCADE,
    FOREIGN KEY (goodIDFK) REFERENCES Good (goodID) ON DELETE CASCADE
);

CREATE TABLE
    Route
(
    routeID     INT AUTO_INCREMENT PRIMARY KEY,
    trainIDFK   INT NOT NULL,
    stationIDFK INT NOT NULL,
    daysLeft    INT NOT NULL,
    FOREIGN KEY (trainIDFK) REFERENCES Train (trainID) ON DELETE CASCADE,
    FOREIGN KEY (stationIDFK) REFERENCES Station (stationID) ON DELETE CASCADE
);