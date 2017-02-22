//
//  UserRegistryController.swift
//  UserRegistry
//
//  Created by qbuser on 10/02/17.
//
//

import Vapor
import HTTP
import Turnstile
import Foundation
 let baseImagePath = workDir+"data/images/"
final class UserRegistryController {
    

    func signUp(_ request: Request) throws ->  ResponseRepresentable {
        
        guard let username = request.data["email"]?.string,
            let password = request.data["password"]?.string else {
                throw Abort.custom(status: .badRequest, message: "Email and password are required")
        }
        if  username.lengthOfBytes(using: String.Encoding.utf8) == 0 || password.lengthOfBytes(using: String.Encoding.utf8) == 0
        {
            throw Abort.custom(status: .badRequest, message: "Email and password are required")
        }
        do {
           let validateEmail: Valid<Email> = try username.validated()
        } catch  {
            throw Abort.custom(status: .badRequest, message: "Please provide a valid email address")

        }
        
        let  email: String = (request.json?["email"]?.string)!.description
        
        var user = User.init(data: request.json!)
        
        if try User.query().filter("email", email).all().count <= 0 {
            
            try user.save()
        }
        else
        {
            throw Abort.custom(status: .accepted, message: "User already exists")
        }
        
        return
            try user.makeJSON()
    }

    func login(_ request: Request) throws ->  ResponseRepresentable {
        
                guard let username = request.data["email"]?.string,
                    let password = request.data["password"]?.string else {
                        throw Abort.custom(status: .badRequest, message: "Email and password are rquired")
                }
                if  username.lengthOfBytes(using: String.Encoding.utf8) == 0 || password.lengthOfBytes(using: String.Encoding.utf8) == 0
                {
                    throw Abort.custom(status: .badRequest, message: "Email and password are rquired")
                }
                let creds = UsernamePassword(username: username, password: password)
                let user = try User.authenticate(credentials: creds) as? User
                if user == nil {
                    throw Abort.custom(status: .accepted, message: "Auth failed")
                } else {
                    return try (user?.makeJSON())!
                }
           }
    
    func allCar(_ request: Request) throws ->  ResponseRepresentable {
        
            return try Car.all().makeJSON()
         }
    func addCar(_ request: Request) throws ->  ResponseRepresentable {
        
        // model and make are mandatory
        guard let model = request.formData?["model"]?.string,
        let make = request.formData?["make"]?.string else {
            throw Abort.custom(status: .badRequest, message: "Make and model is required")
        }
        if  model.lengthOfBytes(using: String.Encoding.utf8) == 0 || make.lengthOfBytes(using: String.Encoding.utf8) == 0
        {
            throw Abort.custom(status: .badRequest, message: "Make and model is required")
        }
        
        var car = Car.init(make: make, model: model)
        var imageName: String? = nil
        // image is optional, save if available
        if let image = request.formData?["image"] {
            
           imageName = String(describing: Date())+(image.filename)!
            let path = baseImagePath+imageName!//workDir+"data/images/"+imageName!
            try Data(image.part.body).write(to: URL(fileURLWithPath: path))
            car.imageURL = imageName
        }

        car.imageURL = imageName
        try car.save()
        return try car.makeJSON()
    }
    
    func showImage(_ request: Request) throws ->  ResponseRepresentable {

        var imageName =  (request.uri.path.components(separatedBy: "/").last)!
        if imageName.hasPrefix("/") {
            imageName = String(imageName.characters.dropFirst())
        }
        let filePath = baseImagePath+imageName// workDir + path
            
        guard
            let attributes = try? Foundation.FileManager.default.attributesOfItem(atPath: filePath),
            let modifiedAt = attributes[.modificationDate] as? Date,
            let fileSize = attributes[.size] as? NSNumber
        else {
                throw Abort.notFound
        }
            
        var headers: [HeaderKey: String] = [:]
            
        // Generate ETag value, "HEX value of last modified date" + "-" + "file size"
        let fileETag = "\(modifiedAt.timeIntervalSince1970)-\(fileSize.intValue)"
        headers["ETag"] = fileETag
            
        // Check if file has been cached already and return NotModified response if the etags match
        if fileETag == request.headers["If-None-Match"] {
            return Response(status: .notModified, headers: headers, body: .data([]))
        }
        
        // Set Content-Type header based on the media type
        // Only set Content-Type if file not modified and returned above.
        if
            let fileExtension = filePath.components(separatedBy: ".").last,
            let type = MediaType.init(fileExtension)// mediaTypes[fileExtension]
        {
            headers["Content-Type"] = type.mediaType
        }
            
        // File exists and was not cached, returning content of file.
        let loader = DataFile()
        if let fileBody = try? loader.load(path:filePath) {
            return Response(status: .ok, headers: headers, body: .data(fileBody))
        } else {
            print("unable to load path")
            throw Abort.notFound
        }

    }
}
