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
        const worldID = ctx.params.worldID
        try {
            const assets = await db.getAllAssets(worldID)

            if (!assets) {
                ctx.set.status = 404
                return {
                    error: "Either the World you selected does not exist or it has no Assets!"
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
        const { name } = ctx.body
        const assetID = ctx.params.assetID
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

            if (funds < cost) {
                ctx.set.status = 400
                return {
                    error: "Not enough funds!"
                }
            }

            const town = await db.buyTown(token, assetID, name)

            return town
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
        const assetID = ctx.params.assetID

        try {
            const town = await db.getTownByID(assetID)

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

    async getAllTowns(ctx) {
        const db = ctx.db
        const worldID = ctx.params.worldID

        try {
            const towns = await db.getAllTowns(worldID)

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

    // async getAllTowns(ctx) {
    //     const db = ctx.db

    //     try {
    //         const towns = await db.getAllTowns()

    //         if (!towns) {
    //             ctx.set.status = 404
    //             return {
    //                 error: "No Towns found!"
    //             }
    //         }

    //         return towns
    //     } catch (error) {
    //         console.log(error)
    //         ctx.set.status = 500
    //         return {
    //             error: "Internal Server error! Please try again later"
    //         }
    //     }
    // }

    //************** Station **************
    async buyStation(ctx) {
        const db = ctx.db
        const assetID = ctx.body.assetID

        try {
            // const token = ctx.headers["authorization"].replace("Bearer ", "")
            // const userID = await db.getUserID(token)

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

    // Get Stations that belong to a specified Asset
    async getStationForAsset(ctx) {
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
    async getAllStations(ctx) {
        const db = ctx.db
        const assetID = ctx.params.assetID

        try {
            const stations = await db.getAllStations(assetID)

            if (!stations) {
                ctx.set.status = 404
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
        const stationID = ctx.params.stationID

        try {
            const station = await db.getStationByID(stationID)

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
    async buyTrain(ctx) {
        const db = ctx.db
        const { stationID } = ctx.body

        try {
            const token = ctx.headers["authorization"].replace("Bearer ", "")
            const userID = await db.getUserID(token)
            const station = await db.getStationByID(stationID)

            if (!station) {
                ctx.set.status = 404
                return {
                    error: "A Station with this ID does not exist"
                }
            }

            if (userID != station.userID) {
                ctx.set.status = 401
                return {
                    error: "Looks like you are not the owner of this station!"
                }
            }

            const funds = await db.getFunds(userID)

            if (funds < station.cost) {
                ctx.set.status = 401
                return {
                    error: "Not enough funds!"
                }
            }

            await db.buyTrain(userID, stationID)
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
        const stationID = ctx.params.stationID
        try {
            const trains = await db.getAllTrains(stationID)

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

    async sendTrain(ctx) {
        const db = ctx.db
        const { trainID, stationID } = ctx.body

        try {
            const station = await db.getStationByID(stationID)

            if (!station) {
                ctx.set.status = 404
                return {
                    error: "A Station with this ID does not exist"
                }
            }

            const route = await db.getRoute(trainID)

            if (route) {
                ctx.set.status = 401
                return {
                    error: "The Train is already on a Route! Wait until it has returned!"
                }
            }

            await db.createRoute(trainID, stationID)
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
        const assetID = ctx.params.assetID
        const token = ctx.headers["authorization"].replace("Bearer ", "")

        try {
            const isOwner = await db.isOwner(token, assetID)

            if (!isOwner) {
                ctx.set.status = 401
                return {
                    error: "You are not the Owner of this Town!"
                }
            }

            const industry = await db.buyIndustry(token, assetID)

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

    // Returns all Industries the User owns
    async getAllIndustries(ctx) {
        const db = ctx.db
        const assetID = ctx.params.assetID

        try {
            const industries = await db.getAllIndustries(assetID)

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
        const industryID = ctx.params.industryID

        try {
            const industry = await db.getIndustryByID(industryID)

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
        const stationID = ctx.params.stationID
        const destStationID = ctx.params.destStationID

        try {
            const token = ctx.headers["authorization"].replace("Bearer ", "")
            const userID = await db.getUserID(token)
            const funds = await db.getFunds(userID)
            const distance = await db.getDistance(stationID, destStationID)

            if (funds < distance) {
                ctx.set.status = 401
                return {
                    error: "Not enough funds!"
                }
            }

            const track = await db.buyRailway(userID, stationID, destStationID)

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
        const stationID = ctx.params.stationID

        try {
            const tracks = await db.getAllRailways(stationID)

            if (!tracks) {
                ctx.set.status = 404
                return {
                    error: "No Railways found!"
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

    async getRailwayForStation(ctx) {
        const db = ctx.db
        const id = ctx.params.stationID

        try {
            const track = await db.getRailwayForStation(id)

            if (!track) {
                ctx.set.status = 404
                return {
                    error: "A Railway with that ID does not exist"
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

    //************** Business **************
    async getAllBusiness(ctx) {
        const db = ctx.db
        const worldID = ctx.params.worldID

        try {
            const business = await db.getAllBusiness(worldID)

            if (!business) {
                ctx.set.satus = 404
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
        const assetID = ctx.params.assetID

        try {
            const business = await db.getBusinessByID(assetID)

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
        const assetID = ctx.params.assetID

        try {
            const business = await db.buyBusiness(assetID)

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

    async getWagon(ctx) {
        const db = ctx.db
        try {
            const token = ctx.headers["authorization"].replace("Bearer ", "")
            const userID = await db.getUserID(token)
            const wagons = await db.getWagons(userID)

            if (!wagons) {
                ctx.set.status = 404
                return {
                    error: "Looks like you dont have any wagons!"
                }
            }

            return wagons
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
