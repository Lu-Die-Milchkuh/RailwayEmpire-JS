import { t } from "elysia"

export const Asset = t.Object(
    {
        assetID: t.Number(),
        type: t.String(),
        level: t.Number(),
        population: t.Number(),
        position: t.Object({
            x: t.Number(),
            y: t.Number()
        }),
        userID: t.Optional(t.Number()),
        worldID: t.Number(),
        cost: t.Number(),
        costPerDay: t.Number()
    },
    {
        examples: {
            assetID: 1,
            type: "TOWN",
            population: 10_000,
            position: {
                x: 100,
                y: 100
            },
            level: 1,
            cost: 250_000,
            costPerDay: 1000,
            worldID: 1,
            userID: 1
        }
    }
)

export const Assets = t.Array(Asset)

export const Station = t.Object(
    {
        stationID: t.Number(),
        assetIDFK: t.Number({
            description: "The ID of the Asset where the Station was build"
        }),
        cost: t.Number(),
        costPerDay: t.Number()
    },
    {
        examples: {
            stattionID: 1,
            assetID: 1,
            cost: 10_000,
            costPerDay: 1000
        }
    }
)

export const Stations = t.Array(Station)
