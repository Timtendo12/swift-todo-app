//
//  File.swift
//  
//
//  Created by Tim Slager on 11/10/2023.
//

import Fluent

struct ExpandToDo: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("todos")
            .field("done", .bool,
                .required)
            .update()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("todos")
            .field("done", .bool,
                .required)
            .delete()
    }
}
