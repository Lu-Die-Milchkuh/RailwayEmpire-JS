import { t } from "elysia"

export const Town = t.Object({
    assetID: t.Number(),
    type: t.Enum()
})
