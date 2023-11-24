import mysql2 from "mysql2/promise"

const DB_CRED = {
    host: Bun.env.DB_HOST,
    port: Bun.env.DB_PORT,
    user: Bun.env.DB_USER,
    password: Bun.env.DB_PASSWORD,
    database: Bun.env.DB_NAME
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
        const query = "CALL sp_registerUser(?,?);"
        return await this.connection.execute(query, [username, password])
    }

    async login(username: string, password: string) {
        const query = "CALL sp_loginUser(?,?);"
        return await this.connection.execute(query, [username, password])
    }
}

export default dbHandler
