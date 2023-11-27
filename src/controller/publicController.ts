class PublicController {
    async register(ctx) {
        const db = ctx.db
        const username = ctx.body.username
        const password = ctx.body.password
        const jwt = ctx.jwt

        try {
            const result = await db.register(username, password)

            if (!result) {
                ctx.set.status = 400
                return {
                    error: "Username already taken!"
                }
            }

            const token = await jwt.sign(ctx.body)
            return {
                token: token
            }
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }

    async login(ctx) {
        const db = ctx.db
        const username = ctx.body.username
        const password = ctx.body.password
        const jwt = ctx.jwt

        try {
            const result = await db.login(username, password)

            if (!result) {
                ctx.set.status = 404
                return {
                    error: "Username not found!"
                }
            }

            const token = await jwt.sign(ctx.body)

            return {
                token: token
            }
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }

    // Return an array of all World containing the ID,CreationDate and the number of Players
    async getWorlds(ctx) {}

    // Return Information about a World specified by a provided ID
    async getWorld(ctx) {
        const id = parseInt(ctx.params.id)
        const db = ctx.db

        if (isNaN(id)) {
            ctx.set.status = 400
            return {
                error: "ID has to be a Number!"
            }
        }

        try {
            const world = await db.getWorld(id)
            if (!world) {
                ctx.set.status = 404
                return {
                    error: "A World with that ID does not exist!"
                }
            }
            return world
        } catch (error) {
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }
}

export default PublicController
