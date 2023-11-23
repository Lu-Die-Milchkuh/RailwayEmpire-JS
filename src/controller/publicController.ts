class PublicController {

	async register(ctx) {
		const db = ctx.db
		const query = "CALL sp_RegisterUser(?,?);"



					
	}

	async login(ctx) {
		

		
	}

	async getWorlds() {}

	async getWorld(id) {}

	
	
}

export default PublicController
