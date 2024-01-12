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

class dbHandler {
    private connection: mysql2.Connection

    // Hack: async constructor
    static async createConnection() {
        return new dbHandler(await mysql2.createConnection(DB_CRED))
    }

    constructor(connection: mysql2.Connection) {
        this.connection = connection
    }

    async getFreeWorld() {
        const query = "CALL sp_getFreeWorld();"
        const result = await this.connection.execute(query)
        return result[0][0][0]?.World
    }

    async isAssetFree(assetID: number) {
        const query = "CALL sp_isAssetFree(?);"
        const result = await this.connection.execute(query, [assetID])
        return result[0][0][0]?.Owner
    }

    async createNewWorld() {
        const query = "CALL sp_createWorld();"
        return await this.connection.execute(query)
    }

    async register(username: string, password: string) {
        const query = "CALL sp_registerUser(?);"
        const jsonData = JSON.stringify({
            username: username,
            password: password
        })
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.Player
    }

    async login(username: string) {
        const query = "CALL sp_loginUser(?);"
        const jsonData = JSON.stringify({
            username: username
        })
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.Player
    }

    async saveToken(username: string, token: string) {
        const query = "CALL sp_saveToken(?);"
        const jsonData = JSON.stringify({
            username: username,
            token: token
        })

        return await this.connection.execute(query, [jsonData])
    }
    async getPlayerByID(id) {
        const query = "CALL sp_getPlayerByID(?);"
        const result = await this.connection.execute(query, [id])
        return result[0][0][0]?.Player
    }

    async getUserID(token) {
        const query = "CALL sp_getUserID(?);"
        const result = await this.connection.execute(query, [token])
        return result[0][0][0]?.userID
    }

    async getFunds(userID) {
        const query = "CALL sp_getFunds(?);"
        const result = await this.connection.execute(query, [userID])
        return result[0][0][0]?.Funds
    }

    async getDistance(src, dst) {
        const query = "CALL sp_getDistance(?,?);"
        const result = await this.connection.execute(query, [src, dst])
        return result[0][0][0]?.Distance
    }

    // Goods
    async buyGood(token: string, type: GoodType, amount: number) {
        const query = "CALL sp_buyGood(?);"
        const jsonData = JSON.stringify({
            token: token,
            type: type,
            amount: amount
        })

        return await this.connection.execute(query, [jsonData])
    }

    async sellGood(token: string, type: GoodType, amount: number) {
        const query = "Call sp_sellGood(?);"
        const jsonData = JSON.stringify({
            token: token,
            type: type,
            amount: amount
        })

        return await this.connection.execute(query, [jsonData])
    }

    // World
    async getWorlds() {
        const query = "CALL sp_getAllWorlds();"
        const result = await this.connection.execute(query)
        return result[0][0][0]?.Worlds
    }

    async getWorldById(id: number) {
        const query = "CALL sp_getWorldById(?);"
        const result = await this.connection.execute(query, [id])
        return result[0][0][0]?.World
    }

    async getAllAssets(token) {
        const query = "CALL sp_getAllAssets(?);"
        const result = await this.connection.execute(query, [token])
        return result[0][0][0]?.Assets
    }

    // Town
    async getAllTowns(worldID) {
        const query = "CALL sp_getAllTowns(?);"
        const result = await this.connection.execute(query, [worldID])
        return result[0][0][0]?.Towns
    }

    async getTownByID(townID) {
        const query = "CALL sp_getTownByID(?)"
        const result = await this.connection.execute(query, [townID])
        return result[0][0][0]?.Town
    }

    async buyTown(token: string, townID: number, name: string = "unnamed") {
        const query = "Call sp_buyTown(?);"
        const jsonData = JSON.stringify({
            token: token,
            assetID: townID,
            name: name
        })
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.Town
    }

    // Railway
    async buyRailway(src, dst) {
        const query = "CALL sp_buyRailway(?);"
        const jsonData = JSON.stringify({
            src: src,
            dst: dst
        })
        const result = await this.connection.execute(query, [jsonData])
        return result[0][0][0]?.Track
    }

    async getAllRailways(stationID) {
        const query = "CALL sp_getAllRailways(?);"
        const result = await this.connection.execute(query, [stationID])
        return result[0][0][0].Tracks
    }

    // Business
    async getAllBusiness(worldID) {
        const query = "CALL sp_getAllBusiness(?);"
        const result = await this.connection.execute(query, [worldID])
        return result[0][0][0]?.Business
    }

    async getBusinessByID(businessID) {
        const query = "CALL sp_getBusinessByID(?);"
        const result = await this.connection.execute(query, [businessID])
        return result[0][0][0]?.Business
    }

    async buyBusiness(businessID) {
        const query = "CALL sp_buyBusiness(?);"
        const result = await this.connection.execute(query, [businessID])
        return result[0][0][0]?.Business
    }

    // Industry
    async getAllIndustries(townID) {
        const query = "CALL sp_getAllIndustries(?)"
        const result = await this.connection.execute(query, [townID])
        return result[0][0][0]?.Industries
    }

    async getIndustryByID(industryID) {
        const query = "CALL sp_getIndustryByID(?);"
        const result = await this.connection.execute(query, [industryID])
        return result[0][0][0]?.Industry
    }

    async buyIndustry(userID, assetID) {
        const query = "CALL sp_buyIndustry(?,?);"
        const result = await this.connection.execute(query, [userID, assetID])
        return result[0][0][0]?.Industry
    }

    // Train
    async buyTrain(userID, stationID) {
        const query = "CALL sp_buyTrain(?);"
        const jsonData = JSON.stringify({
            userID: userID,
            stationID: stationID
        })
        return await this.connection.execute(query, [jsonData])
    }

    async getTrainByID(id) {
        const query = "CALL sp_getTrainByID(?);"
        const result = await this.connection.execute(query, [id])

        return result[0][0][0]?.Train
    }

    async getAllTrains(worldID) {
        const query = "CALL sp_getAllTrains(?);"
        const result = await this.connection.execute(query, [worldID])
        return result[0][0][0]?.Trains
    }

    // Station
    async buyStation(assetID) {
        const query = "CALL sp_buyStation(?);"
        const result = await this.connection.execute(query, [assetID])
        return result[0][0][0]?.Station
    }

    async getStationByID(stationID) {
        const query = "CALL sp_getStationByID(?);"
        const result = await this.connection.execute(query, [stationID])
        return result[0][0][0]?.Station
    }

    async getAllStations(assetID) {
        const query = "CALL sp_getAllStations(?);"
        const result = await this.connection.execute(query, [assetID])
        return result[0][0][0]?.Stations
    }

    // Wagon
    async getWagons(userID) {
        const query = "CALL sp_getWagons(?);"
        const result = await this.connection.execute(query, [userID])
        return result[0][0][0]?.Wagons
    }
}

export default dbHandler
