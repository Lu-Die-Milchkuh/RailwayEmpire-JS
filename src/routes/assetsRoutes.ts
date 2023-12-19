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

    .get("/", assetController.getAllAssets, {
        beforeHandle: validateToken
    })

    .group("/town", { beforeHandle: validateToken }, (plugin) =>
        plugin
            .get("/", assetController.getAllTowns)
            .get(":id", assetController.getTownByID)
            .post("/", assetController.buyTown, {
                body: t.Object({
                    assetID: t.Number()
                }),
                response: {
                    200: "Town",
                    404: t.Object({ error: t.String() })
                }
            })
            .group("/industry", (plugin) =>
                plugin
                    .get("/", assetController.getIndustry)
                    .get("/:id", assetController.getIndustryByID)
                    .post("/", assetController.buyIndustry, {
                        body: t.Object({
                            assetID: t.Number()
                        })
                    })
            )
    )

    .group("/business", { beforeHandle: validateToken }, (plugin) =>
        plugin
            .get("/", assetController.getAllBusiness)
            .get("/:id", assetController.getBusinessByID)
            .post("/", assetController.buyBusiness, {
                body: t.Object({
                    assetID: t.Number()
                })
            })
    )

    .group("/station", (plugin) =>
        plugin
            .get("/", assetController.getStation)
            .get("/:id", assetController.getStationByID)
            .post("/", assetController.buyStation, {
                body: t.Object({
                    assetID: t.Number()
                })
            })
            .group("/railway", (plugin) =>
                plugin
                    .get("/", assetController.getRailway)
                    .post("/", assetController.buyRailway, {
                        body: t.Object({
                            src: t.Number(),
                            dst: t.Number()
                        })
                    })
            )
            .group("/train", (plugin) =>
                plugin
                    .get("/", assetController.getTrains)
                    .get("/:id", assetController.getTrainByID)
                    .post("/", assetController.buyTrain, {
                        body: t.Object({
                            assetID: t.Number()
                        })
                    })
            )
    )

export default assetRoutesPlugin
