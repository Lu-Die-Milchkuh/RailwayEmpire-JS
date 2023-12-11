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

import { generateToken } from "../auth/tokenAuth"

class PublicController {
    async register(ctx) {
        const db = ctx.db
        const username = ctx.body.username
        const password = ctx.body.password

        try {
            const HASHED_PASSWORD = await Bun.password.hash(password, {
                algorithm: "bcrypt"
            })

            await db.register(username, HASHED_PASSWORD)

            const token = await generateToken(ctx)
            return {
                token: token
            }
        } catch (error) {
            if (error.message === "Duplicate entry for username") {
                ctx.set.status = 400
                return {
                    error: "Username already taken!"
                }
            }

            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }

    async login(ctx) {
        const db = ctx.db
        const username = ctx.body.username
        const password = ctx.body.password
        const jwt = ctx.jwt

        try {
            const result = await db.login(username)
            const HASHED_PASSWORD = result[0][0][0]?.password

            if (!HASHED_PASSWORD) {
                ctx.set.status = 404
                return {
                    error: "Username not found!"
                }
            }

            if (!(await Bun.password.verify(password, HASHED_PASSWORD))) {
                ctx.set.status = 401
                return {
                    error: "Wrong Password!"
                }
            }

            const token = await jwt.sign(username)

            await db.saveToken(username, token)

            return {
                token: token
            }
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }

    // Return an array of all World containing the ID,CreationDate and the number of Players
    async getWorlds(ctx) {
        const db = ctx.db

        try {
            const result = await db.getWorlds()
            const worlds = result[0][0][0]?.worlds

            if (!worlds) {
                ctx.set.status = 404
                return {
                    error: "You found a Glitch in the Matrix! There are no Worlds found!"
                }
            }

            return worlds
        } catch (error) {
            console.log(error)

            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }

    // Return Information about a World specified by a provided ID
    async getWorldById(ctx) {
        const id = ctx.params.id
        const db = ctx.db

        const isNum = /^\d+$/.test(id)

        if (!isNum) {
            ctx.set.status = 400
            return {
                error: "ID has to be a Number!"
            }
        }

        try {
            const result = await db.getWorldById(id)
            const world = result[0][0][0]?.world

            if (!world) {
                ctx.set.status = 404
                return {
                    error: "A World with that ID does not exist!"
                }
            }

            return world
        } catch (error) {
            if (
                error.code === "ER_SIGNAL_EXCEPTION" &&
                error.sqlState === "45000" &&
                error.message === "World not found"
            ) {
                ctx.set.status = 404
                return {
                    error: "A World with that ID does not exist!"
                }
            }

            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }
}

export default PublicController
