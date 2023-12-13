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
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }
        }
    }

    async getAllTowns(ctx) {}

    //************** Station **************
    async buyStation(ctx) {}

    // Get all Stations that belong to a Town/Business
    async getAllStations(ctx) {}

    async getStationByID(ctx) {}

    //************** Train **************
    async buyTrain(ctx) {}

    async getTrains(ctx) {}

    async getTrainByID(ctx) {}

    //************** Industry **************
    async buyIndustry(ctx) {}

    async getAllIndustries(ctx) {}

    async getIndustryByID(ctx) {}

    //************** Track **************
    async buyTrack(ctx) {}

    async getTrack(ctx) {}

    //************** Business **************
    async getAllBusiness(ctx) {}

    async getBusinessByID(ctx) {}

    async buyBusiness(ctx) {}
}

export default AssetController
