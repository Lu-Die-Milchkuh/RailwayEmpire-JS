import { generateToken } from "../auth/tokenAuth"

class PublicController {
    async register(ctx) {
        const db = ctx.db
        const username = ctx.body.username
        const password = ctx.body.password

        try {
            const HASHED_PASSWORD = await Bun.password.hash(password, {
                algorithm: "bcrypt"
            })

            await db.register(username, HASHED_PASSWORD)

            const token = await generateToken(ctx)
            return {
                token: token
            }
        } catch (error) {
            if (error.code === "ER_DUP_ENTRY") {
                ctx.set.status = 400
                return {
                    error: "Username already taken!"
                }
            }

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

            const result = await db.login(username)
            const HASHED_PASSWORD = result[0][0][0]?.password

            if (!HASHED_PASSWORD) {
                ctx.set.status = 404
                return {
                    error: "Username not found!"
                }
            }

            if (!(await Bun.password.verify(password, HASHED_PASSWORD))) {
                ctx.set.status = 401
                return {
                    error: "Wrong Password!"
                }
            }

            const token = await jwt.sign(username)

            await db.saveToken(username, token)

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
    async getWorlds(ctx) {
        const db = ctx.db

        // try {

        // }
    }

    // Return Information about a World specified by a provided ID
    async getWorldById(ctx) {
        const id = ctx.params.id
        const db = ctx.db

        const isNum = /^\d+$/.test(id);

        if (!isNum) {
            ctx.set.status = 400
            return {
                error: "ID has to be a Number!"
            }
        }

        try {
            const result = await db.getWorldById(id)
            const world = result[0][0][0]?.world

            if (!world) {
                ctx.set.status = 404
                return {
                    error: "A World with that ID does not exist!"
                }
            }
            return world
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }
}

export default PublicController
