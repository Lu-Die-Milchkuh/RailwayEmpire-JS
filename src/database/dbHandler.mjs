import mysql2 from "mysql2/promise"

class dbHandler {
    // Hack: async constructor
    static async createConnection() {
        return new dbHandler(await mysql2.createConnection())
    }

    constructor(connection) {
        this.connection = connection
    }

    register(username, password) {
        const query = "INSERT INTO User(username,password) VALUES(?,?);"
    }

    login(username, password) {}
}

export default dbHandler
