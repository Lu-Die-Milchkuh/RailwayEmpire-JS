class PublicController {
    async register(ctx) {
        const db = ctx.db
    }

    async login(ctx) {
        console.log(ctx.body)
    }

    // Return an array of all World containing the ID,CreationDate and the number of Players
    async getWorlds(ctx) {}

    // Return Information about a World specified by a provided ID
    async getWorld(ctx) {}
}

export default PublicController
