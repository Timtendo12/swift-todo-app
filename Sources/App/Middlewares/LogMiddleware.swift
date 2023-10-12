//
//  LogMiddleware.swift
//
//
//  Created by Tim Slager on 11/10/2023.
//

import Foundation
import Vapor

struct LogMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        print("Log Middleware");
        return try await next.respond(to: request);
    }
}
