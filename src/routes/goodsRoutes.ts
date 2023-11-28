import { Elysia, t } from "elysia"
import GoodsController from "../controller/goodsController"
import { validateToken } from "../auth/tokenAuth"

const goodsController = new GoodsController()

const goodsRoutesPlugin = new Elysia({ prefix: "/goods" })
    // Schema of the required body
    .model({
        Good: t.Object({
            type: t.String(),
            amount: t.Number()
        })
    })
    .get("/", goodsController.getAllGoods)
    .guard(
        {
            body: "Good",
            error({}) {
                return {
                    error: "Type and Amount expected!"
                }
            }
        },
        (plugin) =>
            plugin
                .post("/buy", goodsController.buyGood, {
                    beforeHandle: validateToken
                })
                .post("/sell", goodsController.sellGood, {
                    beforeHandle: validateToken
                })
    )

export default goodsRoutesPlugin
