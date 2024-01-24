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
        beforeHandle: validateToken,
        response: {
            200: "Assets",
            404: "Error"
        }
    })

    .group("/town", { beforeHandle: validateToken }, (plugin) =>
        plugin
            .get("/", assetController.getAllTowns, {
                response: {
                    200: "Towns",
                    404: "Error"
                }
            })
            .group(":assetID", (plugin) =>
                plugin
                    .get("/", assetController.getTownByID, {
                        response: {
                            200: "Asset",
                            404: "Error"
                        }
                    })
                    .post("/", assetController.buyTown, {
                        body: t.Object({
                            name: t.String()
                        }),
                        error({}) {
                            return {
                                error: "Expected a Name!"
                            }
                        },
                        response: {
                            200: "Town",
                            404: "Error"
                        }
                    })
                    .group("/industry", (plugin) =>
                        plugin
                            .get("/", assetController.getAllIndustries, {
                                response: {
                                    200: "Industries",
                                    404: "Error"
                                }
                            })
                            .get(
                                ":industryID",
                                assetController.getIndustryByID,
                                {
                                    response: {
                                        200: "Industries",
                                        404: "Error"
                                    }
                                }
                            )
                            .post("/", assetController.buyIndustry, {
                                body: t.Object({
                                    type: t.String()
                                }),
                                error({}) {
                                    return {
                                        error: "Expected a Industry Type"
                                    }
                                }
                            })
                    )
                    .group("station", (plugin) =>
                        plugin
                            .get("/", assetController.getStation, {
                                response: {
                                    200: "Station",
                                    404: "Error"
                                }
                            })
                            .post("/", assetController.buyStation)
                            .get(":stationID", assetController.getStationByID, {
                                response: {
                                    200: "Station",
                                    404: "Error"
                                }
                            })
                            .group(":stationID/railway", (plugin) =>
                                plugin
                                    .get("/", assetController.getAllRailways, {
                                        response: {
                                            200: "Railways",
                                            404: "Error"
                                        }
                                    })
                                    .post(
                                        "/:destStationID",
                                        assetController.buyRailway
                                    )
                            )
                            .group(":stationID/train", (plugin) =>
                                plugin
                                    .get("/", assetController.getAllTrains, {
                                        response: {
                                            200: "Train",
                                            404: "Error"
                                        }
                                    })
                                    .get(
                                        ":trainID",
                                        assetController.getTrainByID,
                                        {
                                            200: "Train",
                                            404: "Error"
                                        }
                                    )
                                    .post("/", assetController.buyTrain)
                                    .post(
                                        ":trainID/send/:destinationStationID",
                                        assetController.sendTrain,
                                        {
                                            response: {
                                                401: "Error",
                                                404: "Error"
                                            }
                                        }
                                    )
                                    .get(
                                        ":trainID/wagon",
                                        assetController.getWagon,
                                        {
                                            response: {
                                                200: "Wagon",
                                                404: "Error"
                                            }
                                        }
                                    )
                            )
                    )
            )
    )
    .group("/business", { beforeHandle: validateToken }, (plugin) =>
        plugin
            .get("/", assetController.getAllBusiness, {
                response: {
                    200: "Businesses",
                    404: "Error"
                }
            })
            .group(":assetID", (plugin) =>
                plugin
                    .get("/", assetController.getBusinessByID, {
                        response: {
                            200: "Business",
                            404: "Error"
                        }
                    })
                    .post("/", assetController.buyBusiness, {
                        response: {
                            200: "Business",
                            404: "Error",
                            402: "Error"
                        }
                    })
                    .group("/station", (plugin) =>
                        plugin
                            .get("/", assetController.getStation, {
                                response: {
                                    200: "Station",
                                    404: "Error"
                                }
                            })
                            .get(
                                "/:stationID",
                                assetController.getStationByID,
                                {
                                    200: "Station",
                                    404: "Error"
                                }
                            )
                            .post("/", assetController.buyStation, {
                                response: {
                                    200: "Station",
                                    401: "Error",
                                    402: "Error"
                                }
                            })
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
                                    .get("/", assetController.getAllTrains, {
                                        response: {
                                            200: "Trains",
                                            404: "Error"
                                        }
                                    })
                                    .get(
                                        "/:trainID",
                                        assetController.getTrainByID,
                                        {
                                            response: {
                                                200: "Train",
                                                404: "Error"
                                            }
                                        }
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
