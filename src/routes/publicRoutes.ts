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
import PublicController from "../controller/publicController"

const publicController = new PublicController()

const publicRoutesPlugin = new Elysia()
    .guard(
        {
            body: "User",
            error({}) {
                return {
                    error: "Invalid User Object! Must contain Username and Password only!"
                }
            }
        },
        (plugin) =>
            plugin
                .post("/register", publicController.register, {
                    response: {
                        200: t.Object({
                            userID: t.Number(),
                            token: t.String({ description: "An Access Token" }),
                            worldID: t.Number({
                                description: "The World the Player is part of"
                            })
                        }),
                        400: "Error"
                    }
                })
                .post("/login", publicController.login, {
                    response: {
                        200: t.Object({
                            userID: t.Number(),
                            token: t.String({ description: "An Access Token" }),
                            worldID: t.Number({
                                description: "The World the Player is part of"
                            })
                        }),
                        404: "Error"
                    }
                })
    )
    .group("/world", (plugin) =>
        plugin
            .get("/", publicController.getWorlds, {
                response: {
                    200: "Worlds",
                    404: "Error"
                }
            })
            .get("/:worldID", publicController.getWorldById, {
                params: t.Object({ worldID: t.Numeric() }),
                error({}) {
                    return {
                        error: "ID has to be a number!"
                    }
                },
                response: {
                    200: "World",
                    404: "Error"
                }
            })
    )

export default publicRoutesPlugin
