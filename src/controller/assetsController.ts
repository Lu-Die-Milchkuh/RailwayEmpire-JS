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

import assert from "assert"

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
        const token = ctx.headers["authorization"]

        try {
            const result = await db.getAllAssets(token)
            const assets = result[0][0][0]?.Assets

            if (!assets) {
                ctx.set.status = 404
                return {
                    error: "No Assets found :("
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
        const { townID, name } = ctx.body
        const token = ctx.headers["authorization"]

        try {
            const result = await db.buyTown(token, townID, name)
            const town = result[0][0][0]?.town

            if (!town) {
                ctx.set.status = 404
                return {
                    error: "No Town exists with that ID"
                }
            }

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

    async getTownByID(ctx) {}

    async getAllTowns(ctx) {
        const db = ctx.db

        try {
            const result = await db.getAllTowns()
            const towns = result[0][0][0]?.Towns

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
    async buyStation(ctx) {}

    // Get all Stations that belong to a Town/Business
    async getAllStations(ctx) {
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
    async buyIndustry(ctx) {}

    // Wrapper
    async getIndustry(ctx) {
        // If Query Parameter exist,
        // only get Industries for that specific town
        if (ctx.query.assetID) {
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

    async getAllRailways(ctx) {}
    async getRailwaysForAsset(ctx) {}
    async getRailwayByID(ctx) {}

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
    async getAllBusiness(ctx) {}

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

    async buyBusiness(ctx) {}
}

export default AssetController
