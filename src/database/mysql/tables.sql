DROP DATABASE IF EXISTS Railway;

CREATE DATABASE IF NOT EXISTS Railway;

USE Railway;

CREATE TABLE
    World (
        worldID INT AUTO_INCREMENT PRIMARY KEY,
        creationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        numberOfPlayers INT NOT NULL
    );

CREATE TABLE
    User (
        userID INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        joinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        worldIDFK INT,
        FOREIGN KEY (worldIDFK) REFERENCES World(worldID)
    );

CREATE TABLE
    Token(
        tokenID INT AUTO_INCREMENT PRIMARY KEY,
        userIDFK INT NOT NULL,
        token VARCHAR(512) NOT NULL,
        FOREIGN KEY (userIDFK) REFERENCES User(userID)
    );

CREATE TABLE
    Good(
        goodID INT AUTO_INCREMENT PRIMARY KEY,
        type ENUM('GRAIN', 'BEVERAGE', 'WOOD', 'MEAT', 'MILK', 'BREAD', 'FRUIT', 'PLANKS', 'LEATHER', 'WOOL', 'CHEESE', 'FURNITURE', 'CLOTHING', 'METALS', 'JEWELLERY', 'TOOLS') NOT NULL,
        amount INT NOT NULL
    );

CREATE TABLE
    Asset(
        assetID INT AUTO_INCREMENT PRIMARY KEY,
        type ENUM('RANCH', 'FIELD', 'STATION', 'DEPOT', 'RAIL') NOT NULL,
        name VARCHAR(255),
        population INT DEFAULT 0,
        position POINT NOT NULL,
        userIDFK INT
    );

CREATE TABLE
    Town(
        townID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        level INT NOT NULL DEFAULT 1,
        position POINT NOT NULL,
        population INT NOT NULL,
        userIDFK INT ,
        worldIDFK INT NOT NULL,
        FOREIGN KEY (worldIDFK) REFERENCES World(worldID),
        FOREIGN KEY (userIDFK) REFERENCES User(userID)
    );

CREATE TABLE
    Station(
        stationID INT AUTO_INCREMENT PRIMARY KEY,
        townIDFK INT NOT NULL,
        FOREIGN KEY (townIDFK) REFERENCES Town(townID)
    );

CREATE TABLE
    Track(
        trackID INT AUTO_INCREMENT PRIMARY KEY,
        stationID1FK INT NOT NULL,
        stationID2FK INT NOT NULL,
        FOREIGN KEY (stationID1FK) REFERENCES Station(stationID),
        FOREIGN KEY (stationID2FK) REFERENCES Station(stationID)
    );

