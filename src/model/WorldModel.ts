import { t } from "elysia"
import Player from "./PlayerModel"

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

const Worlds = t.Array(World, {
    examples: [
        {
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
        },
        {
            worldID: 2,
            creationDate: "",
            players: [
                {
                    funds: 6969,
                    userID: 3,
                    joinDate: "",
                    username: "Steve"
                },
                {
                    funds: 10000,
                    userID: 4,
                    joinDate: "",
                    username: "Alex"
                }
            ]
        }
    ]
})

export { World, Worlds }
