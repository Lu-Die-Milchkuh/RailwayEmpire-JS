import Elysia from "elysia"
import AssetController from "../controller/assetsController"

const assetController = new AssetController()

const assetRoutesPlugin = new Elysia({ prefix: "/asset" })
    .get("/", assetController.getAllAssets)
    .group("/train", (app) =>
        app
            .get("/", () => {})
            .get("/:id", () => {})
            .post("/", () => {})
    )
    .group("/station", (app) =>
        app
            .get("/", () => {})
            .get("/:id", () => {})
            .post("/", () => {})
    )
    .group("/business", (app) =>
        app
            .get("/", () => {})
            .get("/:id", () => {})
            .post("/", () => {})
    )

export default assetRoutesPlugin
