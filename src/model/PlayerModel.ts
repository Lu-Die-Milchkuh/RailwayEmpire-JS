import { t } from "elysia"

export const Player = t.Object(
    {
        funds: t.Number(),
        userID: t.Number(),
        joinDate: t.String(),
        username: t.String()
    },
    {
        examples: {
            funds: 100000,
            userID: 1,
            joinDate: "",
            username: "John"
        }
    }
)

export const User = t.Object(
    {
        username: t.String(),
        password: t.String()
    },
    {
        examples: {
            username: "foo",
            password: "bar"
        }
    }
)
