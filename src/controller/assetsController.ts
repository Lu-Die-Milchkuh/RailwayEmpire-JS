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
    async getAllAssets(ctx) {}

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
