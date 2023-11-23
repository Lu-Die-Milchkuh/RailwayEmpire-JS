import PublicController from "../controller/publicController.ts"
import Elysia from "elysia"

export default function (app: Elysia) {
    const publicController = new PublicController()

    app.post("/register", publicController.register)

    app.post("/login", publicController.login)
}
