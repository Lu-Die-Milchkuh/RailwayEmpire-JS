export default async function validateToken(ctx) {
    const jwt = ctx.jwt
    const token = ctx.headers["authorization"]

    console.log("Token: " + token)

    if (!token) {
        ctx.set.status = 401
        return {
            error: "Unauthorized! Missing Token!"
        }
    }

    const profile = await jwt.verify(token, Bun.env.JWT_SECRET)

    if (!profile) {
        ctx.set.status = 401
        return {
            error: "Unauthorized! The provided Token is not valid!"
        }
    }
}
