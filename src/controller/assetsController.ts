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

class AssetController {
    async getAllAssets(ctx) {
        const db = ctx.db
        const worldID = parseInt(ctx.params.worldID)
        try {
            const result = await db.getAllAssets(worldID)

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            const assets = result.data

            // This is a shitty Hack:
            // The Response Guard of Elysia would throw an error if the
            // userID was Null. It is of type optional(number)
            // which can be undefiend but not null ...
            assets.forEach((asset) => {
                if (!asset.userID) {
                    asset.userID = undefined
                }
            })

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
        const assetID = parseInt(ctx.params.assetID)
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const user = await db.getUser(token)
            const name = ctx.body.name
            const result = await db.buyTown(
                parseInt(user.userID),
                assetID,
                name
            )

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            return result.data
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getTownByID(ctx) {
        const db = ctx.db
        const assetID = parseInt(ctx.params.assetID)

        try {
            const result = await db.getTownByID(assetID)

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            let town = result.data

            // Workaround
            if (!town.userID) town.userID = undefined

            return town
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getAllTowns(ctx) {
        const db = ctx.db
        const worldID = parseInt(ctx.params.worldID)

        try {
            const result = await db.getAllTowns(worldID)

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            const towns = result.data

            // Workaround for Null values
            towns.forEach((town) => {
                if (!town.userID) town.userID = undefined
            })

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
        const assetID = parseInt(ctx.params.assetID)
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const user = await db.getUser(token)
            const output = await db.buyStation(user.userID, assetID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    // Get Stations
    async getStation(ctx) {
        const db = ctx.db
        const assetID = parseInt(ctx.params.assetID)

        try {
            const output = await db.getStation(assetID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }
            console.log(output)

            return output.data
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
        const stationID = parseInt(ctx.params.stationID)

        try {
            const output = await db.getStationByID(stationID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
        } catch (error) {
            console.log(error)
            ctx.set.status = 500

            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    //************** Train **************
    async buyTrain(ctx) {
        const db = ctx.db
        const { stationID } = ctx.body

        try {
            const token = ctx.headers["authorization"].replace("Bearer ", "")
            const user = await db.getUser(token)

            const result = await db.buyTrain(user.userID, stationID)

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }
            // Status 200 by Default so no need to send anything
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getAllTrains(ctx) {
        const db = ctx.db
        const stationID = parseInt(ctx.params.stationID)
        try {
            const output = await db.getAllTrains(stationID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
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
        const trainID = parseInt(ctx.params.trainID)

        try {
            const output = await db.getTrainByID(trainID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async sendTrain(ctx) {
        const db = ctx.db
        const destinationStationID = ctx.params.destinationStationID
        const trainID = ctx.params.trainID
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const user = await db.getUser(token)

            const output = await db.createRoute(
                user.userID,
                trainID,
                destinationStationID
            )

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }
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
        const assetID = parseInt(ctx.params.assetID)
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const { type } = ctx.body
            const user = await db.getUser(token)
            const output = await db.buyIndustry(user.userID, assetID, type)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    // Returns all Industries the User owns
    async getAllIndustries(ctx) {
        const db = ctx.db
        const assetID = parseInt(ctx.params.assetID)

        try {
            const output = await db.getAllIndustries(assetID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
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
        const industryID = parseInt(ctx.params.industryID)

        try {
            const output = await db.getIndustryByID(industryID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
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
        const stationID = parseInt(ctx.params.stationID)
        const destStationID = parseInt(ctx.params.destStationID)

        try {
            const token = ctx.headers["authorization"].replace("Bearer ", "")
            const user = await db.getUser(token)

            const output = await db.buyRailway(
                user.userID,
                stationID,
                destStationID
            )

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }
            // Status 200 as Default
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
        const stationID = parseInt(ctx.params.stationID)

        try {
            const output = await db.getAllRailways(stationID)

            if (output.code != 200) {
                return {
                    error: output.message
                }
            }

            return output.data
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
        const worldID = parseInt(ctx.params.worldID)

        try {
            const output = await db.getAllBusiness(worldID)

            if (output.code != 200) {
                return {
                    error: output.message
                }
            }

            let businesses = output.data

            businesses.forEach((business) => {
                if (!business.userID) {
                    business.userID = undefined
                }
            })

            return output.data
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
        const assetID = parseInt(ctx.params.assetID)

        try {
            const output = await db.getBusinessByID(assetID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            let business = output.data

            // Workaround because the Elysia team
            // thought it was a good idea
            // that t.Optional can only be undefined
            // and not null
            if (!business.userID) {
                business.userID = undefined
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
        const assetID = parseInt(ctx.params.assetID)
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const user = await db.getUser(token)
            const output = await db.buyBusiness(user.userID, assetID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getWagon(ctx) {
        const db = ctx.db
        try {
            const token = ctx.headers["authorization"].replace("Bearer ", "")
            const user = await db.getUser(token)
            const output = await db.getWagons(user.userID)

            if (output.code != 200) {
                ctx.set.status = output.code
                return {
                    error: output.message
                }
            }

            return output.data
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
