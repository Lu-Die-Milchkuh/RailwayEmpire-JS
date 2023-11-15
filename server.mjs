import { Elysia } from "elysia"
import swagger from "@elysiajs/swagger"
import publicRoutes from "./src/routes/publicRoutes.mjs"

const PORT = 8080
const app = new Elysia()

app.use(swagger())
app.use(publicRoutes)

app.listen(PORT, () => {
    console.log(`Server is up and listening on Port: ${PORT}`)
})
