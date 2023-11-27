import { Elysia, t } from "elysia"
import AssetController from "../controller/assetsController"
import validateToken from "../auth/tokenAuth"

const assetController = new AssetController()

const assetRoutesPlugin = new Elysia({ prefix: "/asset" })
    .model({
        Town: t.Object({
            name: t.String(),
            posX: t.Number(),
            posY: t.Number()
        }),
        Industry: t.Object({
            type: t.String()
        })
    })
    .get("/", assetController.getAllAssets, { beforeHandle: validateToken })
    .group("/town", (plugin) =>
        plugin
            .get("/", () => {})
            .group("/industry", (plugin) =>
                plugin
                    .get("/", () => {})
                    .get("/:id", () => {})
                    .post("/", () => {})
            )
            .group("/station", (plugin) =>
                plugin
                    .get("/", () => {})
                    .get("/:id", () => {})
                    .get("/track", () => {})
                    .post("/track", () => {})
                    .post("/", () => {})
                    .group("/train", (plugin) =>
                        plugin
                            .get("/", () => {})
                            .get("/:id", () => {})
                            .post("/", () => {})
                    )
            )
    )
    .group("/business", (plugin) =>
        plugin
            .get("/", () => {})
            .get("/:id", () => {})
            .post("/", () => {})
            .group("/station", (plugin) =>
                plugin
                    .get("/", () => {})
                    .get("/:id", () => {})
                    .post("/", () => {})
                    .group("/train", (plugin) =>
                        plugin
                            .get("/", () => {})
                            .get("/:id", () => {})
                            .post("/", () => {})
                    )
            )
    )

export default assetRoutesPlugin
