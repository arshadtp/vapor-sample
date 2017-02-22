//
//  Car.swift
//  UserRegistry
//
//  Created by qbuser on 15/02/17.
//
//

import Fluent
import Vapor
import Foundation

final class Car: Model {
    var id: Node?
    var updatedDate: TimeInterval

    var make: String
    var model: String
    var imageURL: String?
    var exists: Bool = false
    
    init(make: String, model: String) {
        self.id = UUID().uuidString.makeNode()
        self.updatedDate = Date().timeIntervalSinceReferenceDate
        self.make = make
        self.model = model
    }
    init(data: JSON) {
        self.id = UUID().uuidString.makeNode()
        self.updatedDate = Date().timeIntervalSinceNow
        self.make = (data["make"]?.string)!
        self.model = (data["model"]?.string)!
        if let image = data["imageURL"] {
            self.imageURL = (image.string)!
        }
    }

    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        updatedDate = try node.extract("updatedDate")
        make = try node.extract("make")
        model = try node.extract("model")
        imageURL = try node.extract("imageURL")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "make": make,
            "model": model,
            "imageURL": imageURL,
            "updatedDate": updatedDate
            ])
    }
}

extension Car: Preparation {
    static func prepare(_ database: Database) throws {
        
        //Adding our actual migration table and attributes. We are first defining the name of the database table and afterwards what attributes the table should have.
        try database.create("Cars") { users in
            users.string("id")
            users.string("make")
            users.string("model")
            users.string("updatedDate")
            users.string("imageURL", length: 20000, optional: true, unique: false, default: nil)
        }
    }
    
    //This makes sure it gets deleted when reverting the projects database
    static func revert(_ database: Database) throws {
        try database.delete("Cars")
    }
}
