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

type Town = {
    name: string
    position: {
        x: number
        y: number
    }
}

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

    async register(username: string, password: string) {
        const query = "CALL sp_registerUser(?);"
        const jsonData = JSON.stringify({
            username: username,
            password: password
        })
        return await this.connection.execute(query, [jsonData])
    }

    async login(username: string) {
        const query = "CALL sp_loginUser(?);"
        const jsonData = JSON.stringify({
            username: username
        })
        return await this.connection.execute(query, [jsonData])
    }

    async saveToken(username: string, token: string) {
        const query = "CALL sp_saveToken(?);"
        const jsonData = JSON.stringify({
            username: username,
            token: token
        })

        return await this.connection.execute(query, [jsonData])
    }

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

    async buyTown(token: string, townID: number, name: string = "") {
        const query = "Call sp_buyTown(?);"
        const jsonData = JSON.stringify({
            token: token,
            townID: townID,
            name: name
        })
        return await this.connection.execute(query, [jsonData])
    }

    async getWorldById(id: number) {
        const query = "CALL sp_getWorldById(?);"
        return await this.connection.execute(query, [id])
    }
}

export default dbHandler
