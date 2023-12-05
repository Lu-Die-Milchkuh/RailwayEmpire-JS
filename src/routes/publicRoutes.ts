import { Elysia, t } from "elysia"
import PublicController from "../controller/publicController"

const publicController = new PublicController()

const Player =
    t.Object({
        funds: t.Number(),
        userID: t.Number(),
        joinDate: t.String(),
        username: t.String()
    })

const publicRoutesPlugin = new Elysia()
    // Schema of the required body
    .model({
        User: t.Object({
            username: t.String(),
            password: t.String()
        }),
        Player: Player,
        World: t.Object({
            worldID: t.Number(),
            creationDate: t.String(),
            numberOfPlayers: t.Number(),
            players: t.Array(Player)
        })
    })
    .guard(
        {
            body: "User",
            error({ }) {
                return {
                    error: "Invalid User Object! Must contain Username and Password only!"
                }
            }
        },
        (plugin) =>
            plugin
                .post("/register", publicController.register, {
                    response: {
                        200: t.Object({ token: t.String() }),
                        400: t.Object({ error: t.String() })
                    }
                })
                .post("/login", publicController.login, {
                    response: {
                        200: t.Object({ token: t.String() }),
                        404: t.Object({ error: t.String() })
                    }
                })
    )
    .group("/world", (plugin) =>
        plugin
            .get("/", publicController.getWorlds)
            .get("/:id", publicController.getWorldById, {
                response: {
                    200: "World",
                    404: t.Object({
                        error: t.String()
                    })
                }
            })
    )

export default publicRoutesPlugin
