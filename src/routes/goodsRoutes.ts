import { Elysia, t } from "elysia"
import GoodsController from "../controller/goodsController"

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
        (app) =>
            app
                .get("/buy", goodsController.buyGood)
                .post("/sell", goodsController.sellGood)
    )

export default goodsRoutesPlugin
