import Vapor
import MySQL
import VaporMySQL
import HTTP

let drop = Droplet()
// Add providers. This tells Vapor that we are using the VaporMySQL provider, this will bind the data to the database and the models automatically down the line
try drop.addProvider(VaporMySQL.Provider.self)

var workDir: String {
    let parent = #file.characters.split(separator: "/").map(String.init).dropLast().joined(separator: "/")
    let path = "/\(parent)/"
    return path
}

//Making sure that Vapor runs our migrations / preperations for our model(s)
drop.preparations.append(User.self)
drop.preparations.append(Car.self)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

// Adding version middleware which add version number to all API
drop.middleware.append(VersionMiddleware())

let userController = UserRegistryController()

drop.get("createTable") { (request) in
    let tableName = "bike"
    let id: String = "1"
    let name:String = "DominR"
    try drop.database?.create(tableName) { users in
        users.string("id")
        users.string("name", length: 2000, optional: true, unique: false, default: nil)
        users.string("password")
        users.string("email")
        users.string("accessToken")
        users.string("imageURL", length: 2000, optional: true, unique: false, default: nil)
        
    }
 
    return "sd"
}
// Registering route user/* which doesn't require authentication
drop.group("user")
{  request in
        request.post("signUp", handler: userController.signUp)
        request.post("login", handler: userController.login)
}

// Registering route user/* which require authentication
drop.grouped(AuthenticationMiddleware()).group("user")
{  authorized in
    authorized.get("isAutherized") { request in
        // has been authorized
        return "Authewrized user"
    }
    authorized.post("addCar", handler: userController.addCar)
    authorized.get("image/*", handler: userController.showImage)
    authorized.get("allCar", handler: userController.allCar)
}



drop.run()
