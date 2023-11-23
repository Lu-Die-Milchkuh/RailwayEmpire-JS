class PublicController {
    async register(ctx) {
        const db = ctx.db
        const query = "CALL sp_RegisterUser(?,?);"
    }

    async login(ctx) {}

    async getWorlds(ctx) {}

    async getWorld(ctx) {}
}

export default PublicController
