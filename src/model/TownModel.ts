import { t } from "elysia"

export const Town = t.Object({
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
})

export const Towns = t.Array(Town)
