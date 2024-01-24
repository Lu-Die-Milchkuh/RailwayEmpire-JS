/*
 *
 *   MIT License
 *
 *   Copyright (c) 2023 Lucas Zebrowsky
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import mysql2 from "mysql2/promise"
import { GoodType } from "../controller/goodsController"

const DB_CRED = {
    host: Bun.env.DB_HOST || "localhost",
    port: Bun.env.DB_PORT || 3306,
    user: Bun.env.DB_USER || "root",
    password: Bun.env.DB_PASSWORD || "password",
    database: Bun.env.DB_NAME || "default"
}

// Wrapper Class to interact with the Database,
// mostly just converts the input parameters into a format
// the database expects (JSON in this case) and returns the "output" Object it retreives
class dbHandler {
    private connection: mysql2.Connection

    // Hack: async constructor
    static async createConnection() {
        return new dbHandler(await mysql2.createConnection(DB_CRED))
    }

    constructor(connection: mysql2.Connection) {
        this.connection = connection
    }

    async register(username: string, password: string) {
        const query = "CALL sp_registerUser(?);"
        const jsonData = {
            username: username,
            password: password
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async login(username: string) {
        const query = "CALL sp_loginUser(?);"
        const jsonData = {
            username: username
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async saveToken(username: string, token: string) {
        const query = "CALL sp_saveToken(?);"
        const jsonData = {
            username: username,
            token: token
        }

        return await this.connection.execute(query, [jsonData])
    }

    async getProfile(userID) {
        const query = "CALL sp_getProfile(?);"
        const jsonData = {
            userID: userID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0].output
    }

    async getUser(token) {
        const query = "CALL sp_getUser(?);"
        const jsonData = {
            token: token
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0].output
    }

    // Goods
    async buyGood(token: string, type: GoodType, amount: number) {
        const query = "CALL sp_buyGood(?);"
        const jsonData = {
            token: token,
            type: type,
            amount: amount
        }

        return await this.connection.execute(query, [jsonData])
    }

    async sellGood(token: string, type: GoodType, amount: number) {
        const query = "Call sp_sellGood(?);"
        const jsonData = {
            token: token,
            type: type,
            amount: amount
        }

        return await this.connection.execute(query, [jsonData])
    }

    // World
    async getWorlds() {
        const query = "CALL sp_getAllWorlds();"
        const result = await this.connection.execute(query)
        return result[0][0][0].output
    }

    async getWorldById(worldID: number) {
        const query = "CALL sp_getWorldById(?);"
        const jsonData = {
            worldID: worldID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0].output
    }

    async getAllAssets(worldID: number) {
        const query = "CALL sp_getAllAssets(?);"
        const jsonData = {
            worldID: worldID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    // Town
    async getAllTowns(worldID: number) {
        const query = "CALL sp_getAllTowns(?);"
        const jsonData = {
            worldID: worldID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async getTownByID(townID) {
        const query = "CALL sp_getTownByID(?)"
        const jsonData = {
            assetID: townID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async buyTown(userID: number, townID: number, name: string) {
        const query = "Call sp_buyTown(?);"
        const jsonData = {
            userID: userID,
            assetID: townID,
            name: name
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    // Railway
    async buyRailway(userID, src, dst) {
        const query = "CALL sp_buyRailway(?);"
        const jsonData = {
            src: src,
            dst: dst
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async getAllRailways(stationID) {
        const query = "CALL sp_getAllRailways(?);"
        const jsonData = {
            stationID: stationID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    // Business
    async getAllBusiness(worldID) {
        const query = "CALL sp_getAllBusiness(?);"
        const jsonData = {
            worldID: worldID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async getBusinessByID(businessID) {
        const query = "CALL sp_getBusinessByID(?);"
        const jsonData = {
            assetID: businessID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async buyBusiness(userID, businessID) {
        const query = "CALL sp_buyBusiness(?);"
        const jsonData = {
            userID: userID,
            assetID: businessID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    // Industry
    async getAllIndustries(townID) {
        const query = "CALL sp_getAllIndustries(?)"
        const jsonData = {
            assetID: townID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async getIndustryByID(industryID) {
        const query = "CALL sp_getIndustryByID(?);"
        const jsonData = {
            industryID: industryID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async buyIndustry(userID, assetID, type) {
        const query = "CALL sp_buyIndustry(?);"
        const jsonData = {
            userID: userID,
            assetID: assetID,
            type1: type
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    // Train
    async buyTrain(userID, stationID) {
        const query = "CALL sp_buyTrain(?);"
        const jsonData = {
            userID: userID,
            stationID: stationID
        }
        const result = await this.connection.execute(query, [jsonData])

        return result[0][0][0]?.output
    }

    async getTrainByID(trainID) {
        const query = "CALL sp_getTrainByID(?);"
        const jsonData = {
            trainID: trainID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async getAllTrains(stationID) {
        const query = "CALL sp_getAllTrains(?);"
        const jsonData = {
            stationID: stationID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async createRoute(userID: number, trainID: number, stationID: number) {
        const query = "Call sp_createRoute(?);"
        const jsonData = {
            userID: userID,
            trainID: trainID,
            stationID: stationID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    // Station
    async buyStation(userID, assetID) {
        const query = "CALL sp_buyStation(?);"
        const jsonData = {
            userID: userID,
            assetID: assetID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async getStationByID(stationID) {
        const query = "CALL sp_getStationByID(?);"
        const jsonData = {
            stationID: stationID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    async getStation(assetID) {
        const query = "CALL sp_getStation(?);"
        const jsonData = {
            assetID: assetID
        }
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.output
    }

    // Wagon
    async getWagons(userID) {
        const query = "CALL sp_getWagons(?);"
        const jsonData = {
            userID: userID
        }
        const result = await this.connection.execute(query, [userID])
        return result[0][0][0]?.output
    }
}

export default dbHandler
