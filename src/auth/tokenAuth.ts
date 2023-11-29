async function validateToken(ctx) {
    const jwt = ctx.jwt
    const token = ctx.headers["authorization"]

    console.log("Token: " + token)

    if (!token) {
        ctx.set.status = 401
        return {
            error: "Unauthorized! Missing Token!"
        }
    }

    try {
        const profile = await jwt.verify(
            token,
            Bun.env.JWT_SECRET || "I use Arch btw"
        )

        if (!profile) {
            ctx.set.status = 401
            return {
                error: "Unauthorized! The provided Token is not valid!"
            }
        }
    } catch (err) {
        console.log(err)
        ctx.set.status = 500
        return {
            error: "Internal Server Error! Please try again later."
        }
    }
}

async function generateToken(ctx) {
    const db = ctx.db
    const jwt = ctx.jwt
    const username = ctx.body.username

    const token = await jwt.sign(username)
    await db.saveToken(username, token)

    return token
}

export { validateToken, generateToken }
