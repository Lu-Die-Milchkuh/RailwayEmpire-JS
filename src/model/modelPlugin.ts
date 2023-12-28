import Elysia from "elysia"
import { User, Player } from "./PlayerModel"
import { World, Worlds } from "./WorldModel"
import { Industry } from "./IndustryModel"

// Models have to be registered otherwise
// the Swagger Plugin wont be able to generate Documentation
const modelPlugin = new Elysia().model({
    User: User,
    Player: Player,
    World: World,
    Worlds: Worlds,
    Industry: Industry
})

export default modelPlugin
