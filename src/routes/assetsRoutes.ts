import { Elysia, t } from "elysia"
import AssetController from "../controller/assetsController"
import { validateToken } from "../auth/tokenAuth"

const assetController = new AssetController()

const assetRoutesPlugin = new Elysia({ prefix: "/asset" })
    .model({
        Town: t.Object({
            assetID: t.Number(),
            name: t.String(),
            position: t.Object({
                x: t.Number(),
                y: t.Number()
            }),
            owner: t.String()
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
        plugin.get("/", assetController.getAllTowns).guard(
            {
                body: t.Object({
                    townID: t.Number(),
                    name: t.Optional(t.String())
                }),
                error({}) {
                    return {
                        error: "You need to provide a valid TownID and optional a name!"
                    }
                },
                beforeHandle: validateToken
            },
            (plugin) =>
                plugin
                    .post("/", assetController.buyTown, {
                        response: {
                            200: "Town",
                            404: t.Object({ error: t.String() })
                        }
                    })
                    .group("/industry", (plugin) =>
                        plugin
                            .get("/", assetController.getAllIndustries)
                            .get("/:id", assetController.getIndustryByID)
                            .post("/", assetController.buyIndustry)
                    )
                    .group("/station", (plugin) =>
                        plugin
                            .get("/", assetController.getAllStations)
                            .get("/:id", assetController.getStationByID)
                            .get("/track", assetController.getTrack)
                            .post("/track", assetController.buyTrack)
                            .post("/", assetController.buyStation)
                            .group("/train", (plugin) =>
                                plugin
                                    .get("/", assetController.getTrains)
                                    .get("/:id", assetController.getTrainByID)
                                    .post("/", assetController.buyTrain)
                            )
                    )
        )
    )
    .group("/business", { beforeHandle: validateToken }, (plugin) =>
        plugin
            .get("/", assetController.getAllBusiness)
            .get("/:id", assetController.getBusinessByID)
            .guard(
                {
                    body: t.Object({
                        businessID: t.Number()
                    })
                },
                (plugin) =>
                    plugin
                        .post("/", assetController.buyBusiness)
                        .group("/station", (plugin) =>
                            plugin
                                .get("/", assetController.getAllStations)
                                .get("/:id", assetController.getStationByID)
                                .post("/", assetController.buyStation)
                                .group("/train", (plugin) =>
                                    plugin
                                        .get("/", assetController.buyTrain)
                                        .get(
                                            "/:id",
                                            assetController.getTrainByID
                                        )
                                        .post("/", assetController.buyTrain)
                                )
                        )
            )
    )

export default assetRoutesPlugin
