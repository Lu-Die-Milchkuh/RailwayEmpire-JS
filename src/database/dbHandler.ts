import mysql2 from "mysql2/promise"
import { GoodType } from "../controller/goodsController"

type Town = {
    name: string,
    position: {
        x: number,
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
            username: username,
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

    async buyTown(token: string, town: Town) {
        const query = "Call sp_buyTown(?);"
        const jsonData = JSON.stringify({
            token: token,
            town: town
        })

        return await this.connection.execute(query, [jsonData])
    }

    async getWorldById(id: number) {
        const query = "CALL sp_getWorldById(?);"
        return await this.connection.execute(query, [id])
    }
}

export default dbHandler
