/*
 *
 *   MIT License
 *
 *   Copyright (c) 2023 Lucas Zebrowsky
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*
 * WARNING: Prepare for some nasty nesting :)
 */
import { Elysia, t } from "elysia"
import AssetController from "../controller/assetsController"
import { validateToken } from "../auth/tokenAuth"

const assetController = new AssetController()

const assetRoutesPlugin = new Elysia({ prefix: "/world/:worldID/asset" })

    .get("/", assetController.getAllAssets, {
        beforeHandle: validateToken
    })

    .group("/town", { beforeHandle: validateToken }, (plugin) =>
        plugin
            .get("/", assetController.getAllTowns)
            .group(":assetID", (plugin) =>
                plugin
                    .get("/", assetController.getTownByID)
                    .post("/", assetController.buyTown, {
                        body: t.Optional(
                            t.Object({
                                name: t.String({
                                    description: "Optional Name for your Town"
                                })
                            })
                        ),
                        response: {
                            200: "Town",
                            404: t.Object({ error: t.String() })
                        }
                    })
                    .group("/industry", (plugin) =>
                        plugin
                            .get("/", assetController.getAllIndustries)
                            .get(
                                ":industryID",
                                assetController.getIndustryByID,
                                {
                                    response: {
                                        200: "Industry",
                                        404: t.Object({ error: t.String() })
                                    }
                                }
                            )
                            .post("/", assetController.buyIndustry)
                    )
                    .group("station", (plugin) =>
                        plugin
                            .get("/", assetController.getAllStations)
                            .post("/", assetController.buyStation)
                            .get(":stationID", assetController.getStationByID)
                            .group(":stationID/railway", (plugin) =>
                                plugin
                                    .get("/", assetController.getAllRailways)
                                    .post(
                                        "/:destStationID",
                                        assetController.buyRailway
                                    )
                            )
                            .group(":stationID/train", (plugin) =>
                                plugin
                                    .get("/", assetController.getAllTrains)
                                    .get(
                                        ":trainID",
                                        assetController.getTrainByID
                                    )
                                    .post("/", assetController.buyTrain)
                                    .post(
                                        ":trainID/send",
                                        assetController.sendTrain,
                                        {
                                            body: t.Object({
                                                stationID: t.Number({
                                                    description:
                                                        "The ID of the DESTINATION Station"
                                                })
                                            })
                                        }
                                    )
                                    .get(
                                        ":trainID/wagon",
                                        assetController.getWagon
                                    )
                            )
                    )
            )
    )
    .group("/business", { beforeHandle: validateToken }, (plugin) =>
        plugin
            .get("/", assetController.getAllBusiness)
            .group(":assetID", (plugin) =>
                plugin
                    .get("/", assetController.getBusinessByID)
                    .post("/", assetController.buyBusiness)
                    .group("/station", (plugin) =>
                        plugin
                            .get("/", assetController.getAllStations)
                            .get("/:stationID", assetController.getStationByID)
                            .post("/", assetController.buyStation)
                            .group(":stationID/railway", (plugin) =>
                                plugin
                                    .get("/", assetController.getAllRailways)
                                    .post(
                                        "/:destStationID",
                                        assetController.buyRailway
                                    )
                            )
                            .group(":stationID/train", (plugin) =>
                                plugin
                                    .get("/", assetController.getAllTrains)
                                    .get(
                                        "/:trainID",
                                        assetController.getTrainByID
                                    )
                                    .post("/", assetController.buyTrain)
                                    .post(
                                        "/:trainID/send",
                                        assetController.sendTrain,
                                        {
                                            body: t.Object({
                                                stationID: t.Number({
                                                    description:
                                                        "The ID of the DESTINATION Station"
                                                })
                                            })
                                        }
                                    )
                                    .get(
                                        ":trainID/wagon",
                                        assetController.getWagon
                                    )
                            )
                    )
            )
    )

export default assetRoutesPlugin
