import { Elysia } from "elysia"
import swagger from "@elysiajs/swagger"
import { jwt } from "@elysiajs/jwt"
import dbHandler from "./src/database/dbHandler"

// Route Plugins
import publicRoutesPlugin from "./src/routes/publicRoutes"
import assetRoutesPlugin from "./src/routes/assetsRoutes"
import goodsRoutesPlugin from "./src/routes/goodsRoutes"

const PORT = Bun.env.HTTP_PORT || 8080
const db = await dbHandler.createConnection()
const app = new Elysia()

// Decorations can be used to bind
// an Object to the "context" Object of the Elysia instance
app.decorate("db", db)
app.use(swagger())
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

app.listen(PORT, () => {
    console.log(`Server is up and listening on Port: ${PORT}`)
})
