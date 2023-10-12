//
//  AuthenticationMiddleware.swift
//
//
//  Created by Tim Slager on 11/10/2023.
//

import Foundation
import Vapor

struct AuthenticationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Headers: Authorization: Bearer <Token>
        return try await next.respond(to: request);
    }
}
