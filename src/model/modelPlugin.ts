import Elysia from "elysia"
import { User, Player } from "./PlayerModel"
import { World, Worlds } from "./WorldModel"
import { Industry } from "./IndustryModel"
import { Good } from "./GoodModel"
import { Asset, Station } from "./AssetModel"
import { Train, Wagon } from "./TrainModel"

// Models have to be registered otherwise
// the Swagger Plugin wont be able to generate Documentation
const modelPlugin = new Elysia().model({
    User: User,
    Player: Player,
    World: World,
    Worlds: Worlds,
    Industry: Industry,
    Good: Good,
    Asset: Asset,
    Station: Station,
    Train: Train,
    Wagon: Wagon
})

export default modelPlugin
