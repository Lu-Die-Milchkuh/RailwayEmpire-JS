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

import { Elysia, t } from "elysia"
import GoodsController from "../controller/goodsController"
import { validateToken } from "../auth/tokenAuth"

const goodsController = new GoodsController()

const goodsRoutesPlugin = new Elysia({ prefix: "/goods" })
    .get("/", goodsController.getAllGoods, { beforeHandle: validateToken })
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
                    beforeHandle: validateToken,
                    body: "Good",
                    response: {
                        200: "Good",
                        404: t.Object({ error: t.String() })
                    }
                })
                .post("/sell", goodsController.sellGood, {
                    beforeHandle: validateToken,
                    body: "Good",
                    response: {
                        404: t.Object({ error: t.String() })
                    }
                })
    )

export default goodsRoutesPlugin
