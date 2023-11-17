import { Elysia } from "elysia"

const publicRoutes = new Elysia()

publicRoutes.get("/worlds", () => {
    return "/worlds"
})

publicRoutes.get("/worlds/:id", (ctx) => {
    console.log(ctx.params.id)
    return "/worlds/:id"
})

publicRoutes.post("/register", (ctx) => {
    const { username, password } = ctx.body

    if (!username || !password) {
        ctx.set.status = 400
        return {
            error: "A Username and Password has to be provided"
        }
    }

    return { username: username }
})

publicRoutes.post("/login", (ctx) => {
    console.log(ctx.db)
    return "/login"
})

export default publicRoutes

// export function (app) {
//     app.route("/register").post()

//     app.route("/login").post()
// }
