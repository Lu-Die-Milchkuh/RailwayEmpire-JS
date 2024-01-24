import { t } from "elysia"

export const Train = t.Object(
    {
        trackID: t.Number(),
        assetID: t.Number({ description: "ID of the Origin Station" }),
        cost: t.Number(),
        costPerDay: t.Number()
    },
    {
        examples: {
            trackID: 1,
            assetID: 69,
            cost: 50_000,
            costPerDay: 100
        }
    }
)

export const Wagon = t.Object(
    {
        wagonID: t.Number(),
        trainID: t.Number(),
        goodID: t.Number(),
        amount: t.Number()
    },
    {
        examples: {
            wagonID: 1,
            trainID: 4,
            goodID: 2,
            amount: 5
        }
    }
)

export const Trains = t.Array(Train)
