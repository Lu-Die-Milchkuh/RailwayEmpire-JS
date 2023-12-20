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

enum BUSINESS {
    RANCH,
    FIELD,
    FARM,
    LUMBERYARD,
    PLANTATION,
    MINE
}

enum INDUSTRY {
    BREWERY,
    BUTCHER,
    BAKERY,
    SAWMILL,
    CHEESEMAKER,
    CARPENTER,
    TAILOR,
    SMELTER,
    SMITHY,
    JEWLER
}

class AssetController {
    async getAllAssets(ctx) {
        const db = ctx.db
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const assets = await db.getAllAssets(token)

            if (!assets) {
                ctx.set.status = 404
                return {
                    error: "Looks like you do not own any Assets yet :("
                }
            }
            return assets
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    //************** Town **************
    async buyTown(ctx) {
        const db = ctx.db
        const { assetID, name } = ctx.body
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const owner = await db.isAssetFree(assetID)

            if (typeof owner === "undefined") {
                ctx.set.status = 404
                return {
                    error: "An Asset with that ID does not exist"
                }
            }

            if (owner) {
                ctx.set.status = 400
                return {
                    error: "The Asset already belongs to a User!"
                }
            }

            const cost = await db.getAssetCost(assetID)
            const funds = await db.getUserFunds(token)

            if (funds <= -50_000) {
                console.log("DO GAMEOVER HERE")
            }

            if (funds < cost) {
                ctx.set.status = 400
                return {
                    error: "Not enough funds!"
                }
            }

            const town = await db.buyTown(token, assetID, name)

            return {
                town: town
            }
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getTowns(ctx) {
        if (typeof ctx.query.worldID === "undefined") {
            this.getTownsForWorld(ctx)
        } else {
            this.getAllTowns(ctx)
        }
    }

    async getTownByID(ctx) {
        const db = ctx.db
        const id = ctx.params.id

        try {
            const town = await db.getTownByID(id)

            if (!town) {
                ctx.set.status = 404
                return {
                    error: "No Town exists with that ID"
                }
            }

            return town
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    private async getTownsForWorld(ctx) {
        const db = ctx.db
        const worldID = ctx.query.worldID

        try {
            const towns = await db.getTownsForWorld(worldID)

            if (!towns) {
                ctx.set.status = 404
                return {
                    error: "No Towns found in this World!"
                }
            }

            return towns
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    private async getAllTowns(ctx) {
        const db = ctx.db

        try {
            const towns = await db.getAllTowns()

            if (!towns) {
                ctx.set.status = 404
                return {
                    error: "No Towns found!"
                }
            }

            return towns
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    //************** Station **************
    async buyStation(ctx) {
        const db = ctx.db
        const assetID = ctx.body.assetID

        try {
            const station = await db.buyStation(assetID)

            if (!station) {
                ctx.set.status = 400
                return {
                    error: "Failed to buy Station!"
                }
            }

            return station
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getStation(ctx) {
        if (typeof ctx.query.assetID !== "undefined") {
            this.getStationForAsset(ctx)
        } else {
            this.getAllStations(ctx)
        }
    }

    // Get Stations that belong to a specified Asset
    private async getStationForAsset(ctx) {
        const db = ctx.db
        const assetID = ctx.query.assetID

        try {
            const station = await db.getStationForAsset(assetID)

            if (!station) {
                ctx.set.status = 404
                return {
                    error: "Either there is no Asset with that ID or ir has no Stations!"
                }
            }

            return station
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    // Get all Stations
    private async getAllStations(ctx) {
        const db = ctx.db

        try {
            const result = await db.getAllStations()
            const stations = result[0][0][0]?.Stations

            if (!stations) {
                ctx.sets.status = 404
                return {
                    error: "No Stations found!"
                }
            }

            return stations
        } catch (error) {
            console.log(error)
            ctx.set.status = 500

            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getStationByID(ctx) {
        const db = ctx.db
        const id = ctx.params.id

        try {
            const result = await db.getStationByID(id)
            const station = result[0][0][0]?.Station

            if (!station) {
                ctx.set.status = 404
                return {
                    error: "A Station with that ID does not exist"
                }
            }

            return station
        } catch (error) {
            console.log(error)
            ctx.set.status = 500

            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    //************** Train **************
    async buyTrain(ctx) {}

    async getTrains(ctx) {
        const db = ctx.db
        try {
            const result = await db.getAllTrains()
            const trains = result[0][0][0]?.Trains

            if (!trains) {
                ctx.set.status = 404
                return {
                    error: "No Trains found+"
                }
            }

            return trains
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getTrainByID(ctx) {
        const db = ctx.db
        const id = ctx.params.id

        try {
            const result = await db.getTrainByID(id)
            const train = result[0][0][0]?.Train

            if (!train) {
                ctx.set.status = 404
                return {
                    error: "A Train with that ID does not exist"
                }
            }

            return train
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    //************** Industry **************
    async buyIndustry(ctx) {
        const db = ctx.db
        const assetID = ctx.body.assetID

        try {
            const result = await db.buyIndustry(assetID)
            const industry = result[0][0][0]?.Industry

            if (!industry) {
                ctx.set.status = 401
                return {
                    error: "Failed to buy Industry"
                }
            }

            return industry
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    // Wrapper
    async getIndustry(ctx) {
        // If Query Parameter exist,
        // only get Industries for that specific town
        if (typeof ctx.query.assetID !== "undefined") {
            this.getIndustryForTown(ctx)
        } else {
            this.getAllIndustries(ctx)
        }
    }

    // Returns an Array of all Industries associated with a specific town
    private getIndustryForTown(ctx) {
        const db = ctx.db
    }

    // Returns all Industries the User owns
    private async getAllIndustries(ctx) {
        const db = ctx.db

        try {
            const result = await db.getAllIndustries()
            const industries = result[0][0][0]?.Industries

            if (!industries) {
                ctx.set.status = 404
                return {
                    error: "No Industries found!"
                }
            }

            return industries
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getIndustryByID(ctx) {
        const db = ctx.db
        const id = ctx.params.id
        try {
            const result = await db.getIndustryByID(id)
            const industry = result[0][0][0]?.Industry

            if (!industry) {
                ctx.set.status = 404
                return {
                    error: "A Industry with that ID does not exist!"
                }
            }

            return industry
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    //************** Railway **************

    async buyRailway(ctx) {
        const db = ctx.db
        const assetID = ctx.query.assetID
        const { src, dst } = ctx.body

        if (!src || !dst) {
            ctx.set.status = 401
            return {
                error: "Expected a Source and Destination ID!"
            }
        }

        try {
            const result = await db.buyRailway(assetID, src, dst)
            const track = result[0][0][0].Track

            if (!track) {
                ctx.set.status = 401
                return {
                    error: "Failed to build Railway! Either Source or Destination Station does not exist"
                }
            }

            return track
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getAllRailways(ctx) {
        const db = ctx.db

        try {
            const result = await db.getAllRailways()
            const railways = result[0][0][0]?.Railways

            if (!railways) {
                ctx.set.status = 404
                return {
                    error: "No Railways found!"
                }
            }

            return railways
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }
    async getRailwaysForAsset(ctx) {}
    async getRailwayByID(ctx) {
        const db = ctx.db
        const id = ctx.params.id

        try {
            const result = await db.getRailwayByID(id)
            const railway = result[0][0][0]?.Railway

            if (!railway) {
                ctx.set.status = 404
                return {
                    error: "A Railway with that ID does not exist"
                }
            }

            return railway
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getRailway(ctx) {
        const db = ctx.db
        const assetID = ctx.query.assetID

        try {
            const results = await db.getTracks(assetID)
            const tracks = results[0][0][0]?.Tracks

            if (!tracks) {
                ctx.set.status = 404
                return {
                    error: "A Track with that ID does not exist"
                }
            }

            return tracks
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    //************** Business **************
    async getAllBusiness(ctx) {
        const db = ctx.db

        try {
            const result = await db.getAllBusiness()
            const business = result[0][0][0]?.Business

            if (!business) {
                ctx.set.sattus = 404
                return {
                    error: "No Business found!"
                }
            }

            return business
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getBusinessByID(ctx) {
        const db = ctx.db
        const id = ctx.params.id

        try {
            const result = await db.getBusinessByID(id)
            const business = result[0][0][0]?.Business

            if (!business) {
                ctx.set.status = 404
                return {
                    error: "A Businesss with that ID does not exist"
                }
            }

            return business
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async buyBusiness(ctx) {
        const db = ctx.db
        const assetID = ctx.body.assetID

        try {
            const result = await db.buyBusiness(assetID)
            const business = result[0][0][0]?.Business

            if (!business) {
                ctx.set.status = 404
                return {
                    error: "Failed to buy Business!"
                }
            }

            return business
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }
}

export default AssetController
