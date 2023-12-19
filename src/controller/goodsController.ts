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

function isGood(type: string): type is GoodType {
    return Object.values(GoodType).includes(type as GoodType)
}

class GoodsController {
    async sellGood(ctx) {
        const db = ctx.db
        const { type, amount } = ctx.body
        const token = ctx.headers["authorization"]

        try {
            console.log(isGood(GoodType.BEVERAGE))
            if (isGood(type)) {
                ctx.set.status = 400
                return {
                    error: "Invalid Good Type!"
                }
            }
            await db.sellGood(token, type, amount)
        } catch (error) {
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
        } catch (error) {
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
