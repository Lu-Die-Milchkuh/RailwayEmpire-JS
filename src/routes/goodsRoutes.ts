import Elysia from "elysia"

const goodsRoutesPlugin = new Elysia({ prefix: "/good" }).get("/", () => {})

export default goodsRoutesPlugin
