import { t } from "elysia"
import { Player } from "./PlayerModel"

const World = t.Object(
    {
        worldID: t.Number(),
        creationDate: t.String(),
        players: t.Array(Player)
    },
    {
        examples: {
            worldID: 1,
            creationDate: "",
            players: [
                {
                    funds: 50000,
                    userID: 1,
                    joinDate: "",
                    username: "John"
                },
                {
                    funds: 100000,
                    userID: 2,
                    joinDate: "",
                    username: "Tobias"
                }
            ]
        }
    }
)

const Worlds = t.Array(World)

export { World, Worlds }
