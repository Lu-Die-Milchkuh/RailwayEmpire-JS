import PublicController from "../controller/publicController"
import { Elysia, t } from "elysia"

const publicController = new PublicController()

const publicRoutesPlugin = new Elysia()
    .guard(
        {
            body: t.Object({
                username: t.String(),
                password: t.String()
            }),
            error({}) {
                return {
                    error: "Expected a Username and Password"
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
