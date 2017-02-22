//
//  Auth.swift
//  UserRegistry
//
//  Created by qbuser on 14/02/17.
//
//

import Foundation
import HTTP
import Core
import Vapor
import Turnstile

final class AuthenticationMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        guard let accessToken = request.headers["accessToken"]?.string else {
            throw Abort.custom(status:.nonAuthoritativeInformation, message: "Authentication failed")
        }
        
    let creds = AccessToken.init(string: accessToken)
       if  (try User.authenticate(credentials: creds) as? User) != nil
       {
        return try next.respond(to: request)

        }
        else
       {
        throw Abort.custom(status: .nonAuthoritativeInformation, message: "Authentication failed")

        }
    }
    
}
