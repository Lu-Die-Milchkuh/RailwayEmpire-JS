import { t } from "elysia"

export const Industry = t.Object(
    {
        industryID: t.Number(),
        type: t.String()
    },
    {
        examples: {
            industryID: 1,
            type: "BAKERY"
        }
    }
)
