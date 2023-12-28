import { t } from "elysia"

export const Good = t.Object(
    {
        type: t.Enum(
            t.String({
                description:
                    "Valid Types: 'MAIL','PASSENGER','FRUIT','WHEAT','CATTLE','GRAIN','WOOD','MILK','PLANKS','LEATHER','WOOL','ORE','TOOLS','GEMS','BEVERAGE','MEAT','BREAD','CHEESE','FURNITURE','CLOTHING','METALS','JEWELLERY'"
            })
        ),
        amount: t.Number({ description: "Total Amount of Good" })
    },
    {
        examples: {
            type: "GRAIN",
            amount: 3
        }
    }
)
