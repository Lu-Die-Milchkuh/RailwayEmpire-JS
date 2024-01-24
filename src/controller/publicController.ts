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
                algorithm: "argon2i"
            })

            const result = await db.register(username, HASHED_PASSWORD)

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            const player = result.data

            const token = await generateToken(ctx)

            return {
                userID: player.userID,
                token: token,
                worldID: player.worldID
            }
        } catch (error) {
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

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            const player = result.data

            const HASHED_PASSWORD = player.password

            if (!(await Bun.password.verify(password, HASHED_PASSWORD))) {
                ctx.set.status = 401
                return {
                    error: "Wrong Password!"
                }
            }

            const token = await jwt.sign(username)

            await db.saveToken(username, token)

            return {
                userID: player.userID,
                token: token,
                worldID: player.worldIDFK
            }
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }

    // Return an array of all Worlds containing the ID,CreationDate and the number of Players
    async getWorlds(ctx) {
        const db = ctx.db

        try {
            const result = await db.getWorlds()

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            return result.data
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
        const db = ctx.db
        const worldID = parseInt(ctx.params.worldID)

        try {
            const result = await db.getWorldById(worldID)

            if (result.code != 200) {
                ctx.set.status = result.code
                return {
                    error: result.message
                }
            }

            return result.data
        } catch (error) {
            console.log(error)
            ctx.set.status = 500
            return {
                error: "Internal Server error! Please try again later."
            }
        }
    }
}

export default PublicController
