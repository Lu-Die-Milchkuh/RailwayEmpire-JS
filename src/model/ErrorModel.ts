import { t } from "elysia"

export const Error = t.Object(
    {
        error: t.String({
            description:
                "An Error Message descriping why the oepration was not successful"
        })
    },
    {
        examples: {
            error: "ID not found"
        }
    }
)
