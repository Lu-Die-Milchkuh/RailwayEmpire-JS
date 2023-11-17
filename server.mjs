import { Elysia } from "elysia"
import swagger from "@elysiajs/swagger"
import publicRoutes from "./src/routes/publicRoutes.mjs"
import dbHandler from "./src/database/dbHandler.mjs"

const PORT = 8080
const db = await dbHandler.createConnection()
const app = new Elysia()

publicRoutes.decorate("db", db)

app.use(swagger())
app.use(publicRoutes)

app.listen(PORT, () => {
    console.log(`Server is up and listening on Port: ${PORT}`)
})
