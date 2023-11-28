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
    Town(
        townID INT AUTO_INCREMENT PRIMARY KEY,

)
