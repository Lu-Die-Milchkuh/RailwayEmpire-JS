import PublicController from "../controller/publicController.ts"

export function (app: Elysia) {

    const publicController = new PublicController()
    
    app.route("/register").post(publicController.register)

    app.route("/login").post(publicController.login)
}
