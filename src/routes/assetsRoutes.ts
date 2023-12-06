import { Elysia, t } from "elysia"
import AssetController from "../controller/assetsController"
import { validateToken } from "../auth/tokenAuth"

const assetController = new AssetController()

const assetRoutesPlugin = new Elysia({ prefix: "/asset" })
    .model({
        Town: t.Object({
            assetID: t.Optional(t.Number()),
            name: t.String(),
            position: t.Object({
                x: t.Number(),
                y: t.Number()
            }),
            owner: t.Optional(t.String())
        }),
        Business: t.Object({
            type: t.String(),
            position: t.Object({
                x: t.Number(),
                y: t.Number()
            })
        })
    })
    .get("/", assetController.getAllAssets, { beforeHandle: validateToken })
    .group("/town", (plugin) =>
        plugin
            .get("/", assetController.getAllTowns, { beforeHandle: validateToken })
            .post("/", assetController.buyTown, {
                body: "Town",
                response: {
                    200: "Town",
                    401: t.Object({ error: t.String() })
                },
                error({ }) {
                    return {
                        error: "Missing Town Object!"
                    }
                }, beforeHandle: validateToken
            })
            .group("/industry", (plugin) =>
                plugin
                    .get("/", () => { }, { beforeHandle: validateToken })
                    .get("/:id", () => { }, { beforeHandle: validateToken })
                    .post("/", () => { }, { beforeHandle: validateToken })
            )
            .group("/station", (plugin) =>
                plugin
                    .get("/", () => { }, { beforeHandle: validateToken })
                    .get("/:id", () => { }, { beforeHandle: validateToken })
                    .get("/track", () => { }, { beforeHandle: validateToken })
                    .post("/track", () => { }, { beforeHandle: validateToken })
                    .post("/", () => { }, { beforeHandle: validateToken })
                    .group("/train", (plugin) =>
                        plugin
                            .get("/", () => { }, { beforeHandle: validateToken })
                            .get("/:id", () => { }, {
                                beforeHandle: validateToken
                            })
                            .post("/", () => { }, {
                                beforeHandle: validateToken
                            })
                    )
            )
    )
    .group("/business", (plugin) =>
        plugin
            .get("/", () => { }, { beforeHandle: validateToken })
            .get("/:id", () => { }, { beforeHandle: validateToken })
            .post("/", () => { }, { beforeHandle: validateToken })
            .group("/station", (plugin) =>
                plugin
                    .get("/", () => { }, { beforeHandle: validateToken })
                    .get("/:id", () => { }, { beforeHandle: validateToken })
                    .post("/", () => { }, { beforeHandle: validateToken })
                    .group("/train", (plugin) =>
                        plugin
                            .get("/", () => { }, { beforeHandle: validateToken })
                            .get("/:id", () => { }, {
                                beforeHandle: validateToken
                            })
                            .post("/", () => { }, {
                                beforeHandle: validateToken
                            })
                    )
            )
    )

export default assetRoutesPlugin
