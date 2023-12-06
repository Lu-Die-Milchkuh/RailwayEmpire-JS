export enum GoodType {
    GRAIN,
    BEVERAGE,
    WOOD,
    MEAT,
    MILK,
    BREAD,
    FRUIT,
    PLANKS,
    LEATHER,
    WOOL,
    CHEESE,
    FURNITURE,
    CLOTHING,
    METALS,
    JEWELLERY,
    TOOLS
}

class GoodsController {
    async sellGood(ctx) {
        const db = ctx.db
        const { type, amount } = ctx.body
        const token = ctx.headers["authorization"]

        try {
            if (type in GoodType) {

            }
            await db.sellGood(token, type, amount)


        }
        catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server Error! Try again later"
            }
        }

    }

    async buyGood(ctx) {
        const db = ctx.db
        const { type, amount } = ctx.body
        const token = ctx.headers["authorization"]

        try {
            const good = await db.buyGood(token, type, amount)

            return {
                good: good
            }
        }
        catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server Error! Try again later"
            }
        }
    }

    async getAllGoods(ctx) {
        const token = ctx.headers["authorization"]
        const db = ctx.db

        try {
            const result = await db.getAllGoods(token)



        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server Error! Try again later"
            }
        }
    }
}

export default GoodsController
