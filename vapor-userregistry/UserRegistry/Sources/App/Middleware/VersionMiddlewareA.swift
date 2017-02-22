//
//  VersionMiddlewareA.swift
//  UserRegistry
//
//  Created by qbuser on 10/02/17.
//
//

import HTTP
import Core
import Vapor
final class VersionMiddleware: Middleware {
    
func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    
       let response = try next.respond(to: request)
        response.headers["Version"] = "API v111111.0"
        return response
    }
    
}

