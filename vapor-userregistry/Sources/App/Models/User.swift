//
//  User.swift
//  UserRegistry
//
//  Created by qbuser on 09/02/17.
//
//
import Fluent
import Vapor
import Foundation
import Auth
import Turnstile
import BCrypt

final class User: Model {
    var id: Node?
    var name: String?
    var password: String
    var email: String
    var imageURL: String?
    var accessToken: String
    var exists: Bool = false
    
    init(data: JSON) {
        self.id = UUID().uuidString.makeNode()
        if let name = data["name"] {
            self.name = name.string!
        }
        self.password = BCrypt.hash(password: (data["password"]?.string)!)
        self.email = (data["email"]?.string)!
        if let image = data["imageURL"] {
            self.imageURL = (image.string)!
        }
        self.accessToken =  UUID().uuidString
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        password = try node.extract("password")
        email = try node.extract("email")
        imageURL = try node.extract("imageURL")
        accessToken = try node.extract("accessToken")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "password": password,
            "email": email,
            "imageURL": imageURL,
            "accessToken":accessToken
            ])
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        
        //Adding our actual migration table and attributes. We are first defining the name of the database table and afterwards what attributes the table should have.
        
        try database.create("Users") { users in
            users.string("id")
            users.string("name", length: 2000, optional: true, unique: false, default: nil)
            users.string("password")
            users.string("email")
            users.string("accessToken")
            users.string("imageURL", length: 2000, optional: true, unique: false, default: nil)

        }
    }
    
    //This makes sure it gets deleted when reverting the projects database
    static func revert(_ database: Database) throws {
        try database.delete("Users")
    }
}

extension User: Auth.User {
    
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        let user: User?
        
        switch credentials {
        case let id as Identifier:
            user = try User.find(id.id)
        case let accessToken as AccessToken:
            user = try User.query().filter("accessToken", accessToken.string).first()
        case let apiKey as APIKey:
            user = try User.query().filter("email", apiKey.id).filter("password", apiKey.secret).first()
        case let usernamePassword as UsernamePassword:
            let fetchedUser = try User.query().filter("email", usernamePassword.username).first()
            guard let user = fetchedUser else {
                throw Abort.custom(status: .networkAuthenticationRequired, message: "Invalid user name or password.")
            }
            do {
                if try BCrypt.verify(password: usernamePassword.password, matchesHash: (fetchedUser?.password)!) == true {
                    return user
                }
                else
                {
                    throw Abort.custom(status: .networkAuthenticationRequired, message: "Invalid user name or password.")
  
                }
            } catch  {
                throw Abort.custom(status: .networkAuthenticationRequired, message: "Invalid user name or password.")
  
            }
//            if BCrypt.hash(password: usernamePassword.password) == fetchedUser?.password {
//                return user
//            }
//            else {
//                throw Abort.custom(status: .networkAuthenticationRequired, message: "Invalid user name or password.")
//            }
        default:
            throw Abort.custom(status: .badRequest, message: "Authentication failed")
        }
        
        guard let u = user else {
            throw Abort.custom(status: .badRequest, message: "Authentication failed")
        }
        
        return u
    }
    
    static func register(credentials: Credentials) throws -> Auth.User {
        
        throw Abort.custom(status: .forbidden, message: "Unsupported credential type.")

    }}
