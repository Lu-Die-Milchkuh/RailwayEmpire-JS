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
    async buyTown(ctx) {
        const db = ctx.db
        const town = ctx.body.town
        const token = ctx.headers["authorization"]

        try {

            const result = await db.buyTown(token, town)
            const newTown = result[0][0][0]?.town

            if (!newTown) {
                ctx.set.status = 404
                return {
                    error: "No Town found on that position"
                }
            }

            return {
                town: newTown
            }

        } catch (error) {

            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later"
            }

        }
    }

    async buyIndustry(ctx) { }

    async buyStation(ctx) { }

    async buyTrain(ctx) { }

    async buyTrack(ctx) { }

    async getAllTowns(ctx) { }

    async getAllAssets(ctx) { }
}

export default AssetController
