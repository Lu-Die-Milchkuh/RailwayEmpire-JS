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
}

async function generateToken(ctx) {
    const db = ctx.db
    const jwt = ctx.jwt
    const username = ctx.body.username

    const token = await jwt.sign(ctx.body)
    await db.saveToken(username, token)

    return token
}

export { validateToken, generateToken }
