import Elysia from "elysia"
import { User, Player } from "./PlayerModel"
import { World, Worlds } from "./WorldModel"
import { Industry } from "./IndustryModel"
import { Good } from "./GoodModel"
import { Asset, Assets, Station, Stations } from "./AssetModel"
import { Train, Wagon } from "./TrainModel"
import { Error } from "../model/ErrorModel"
import { Town, Towns } from "../model/TownModel"

// Models have to be registered otherwise
// the Swagger Plugin wont be able to generate Documentation
const modelPlugin = new Elysia().model({
    User: User,
    Player: Player,
    World: World,
    Worlds: Worlds,
    Industry: Industry,
    Good: Good,
    Assets: Assets,
    Asset: Asset,
    Station: Station,
    Stations: Stations,
    Train: Train,
    Wagon: Wagon,
    Error: Error,
    Town: Town,
    Towns: Towns
})

export default modelPlugin
