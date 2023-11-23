import { Elysia } from "elysia"
import swagger from "@elysiajs/swagger"
import publicRoutes from "./src/routes/publicRoutes.ts"
import dbHandler from "./src/database/dbHandler.ts"

const PORT = 8080
const db = await dbHandler.createConnection()
const app = new Elysia()

// Decorations can be used to bind 
// an Object to the "context" Object of the Elysia instance
app.decorate("db", db)

// app.use(swagger())
// Populate the routes
app.use(publicRoutes)

app.listen(PORT, () => {
    console.log(`Server is up and listening on Port: ${PORT}`)
})
