import { Elysia, t } from "elysia"
import PublicController from "../controller/publicController"

const publicController = new PublicController()

const publicRoutesPlugin = new Elysia()
    // Schema of the required body
    .model({
        User: t.Object({
            username: t.String(),
            password: t.String()
        })
    })
    .guard(
        {
            body: "User",
            error({}) {
                return {
                    error: "Invalid User Object! Must contain Username and Password only!"
                }
            }
        },
        (app) =>
            app
                .post("/register", publicController.register)
                .post("/login", publicController.login)
    )
    .group("/world", (app) =>
        app
            .get("/", publicController.getWorlds)
            .get("/:id", publicController.getWorld)
    )

export default publicRoutesPlugin
