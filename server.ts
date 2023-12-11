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

import { Elysia } from "elysia"
import swagger from "@elysiajs/swagger"
import { jwt } from "@elysiajs/jwt"
import { cors } from "@elysiajs/cors"
import dbHandler from "./src/database/dbHandler"

// Route Plugins
import publicRoutesPlugin from "./src/routes/publicRoutes"
import assetRoutesPlugin from "./src/routes/assetsRoutes"
import goodsRoutesPlugin from "./src/routes/goodsRoutes"

const PORT = Bun.env.HTTP_PORT || 8080
const db = await dbHandler.createConnection()
const app = new Elysia()

app.use(swagger())
app.use(cors())
app.use(
    jwt({
        name: "jwt",
        secret: Bun.env.JWT_SECRET || "I use Arch btw",
        exp: "1d" // Expires in 24H
    })
)

// Populate the routes
app.use(publicRoutesPlugin)
app.use(assetRoutesPlugin)
app.use(goodsRoutesPlugin)

// Decorations can be used to bind
// an Object to the "context" Object of the Elysia instance
app.decorate("db", db)

app.listen(PORT, () => {
    console.log(`Server is up and listening on Port: ${PORT}`)
})
