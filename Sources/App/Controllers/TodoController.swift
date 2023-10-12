//
//  TodoController.swift
//
//
//  Created by Tim Slager on 11/10/2023.
//

import Foundation
import Vapor

struct TodoController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("todos") { route in
            route.get(use: index);
            route.get("remove", ":todoId", use: destroy);
            route.get("toggle", ":todoId", use: toggle);
        }
    }
    
    /**
     * This is the index method. It returns a view with all ToDos.
     *
     * returns: (Leaf) ViewRenderer
     */
    func index(req: Request) async throws -> View {
        let title = req.query[String.self, at: "todo"];
        
        if (title != nil) {
            print("/todos?todo=\(title!)");
            // url decode title
            let title = title!.removingPercentEncoding!;
            
            // generate new uuid id
            let id = UUID();
            let todo = Todo(id: id,title: title, done: false);
            
            do {
                try await todo.save(on: req.db);
            } catch {
                print("Error saving todo: \(error)");
            }
        }
        
        // get all todos
        var todos = try await Todo.query(on: req.db).all();
        
        let sortType = parseSortType(req: req);
        
        if (sortType != nil) {
            todos = try sortItems(todos: todos, sortType: sortType!);
        }
        
        return try await req.view.render("todos/index", ["todos": todos]);
    }
    
    func destroy(req: Request) async throws -> Response {
        let todoId = parseToDoId(req: req);
        
        let todo = try await Todo.find(todoId, on: req.db);
        
        if (todo != nil) {
            try await todo!.delete(on: req.db);
        }
        
        return req.redirect(to: "/todos");
    }
    
    func toggle(req: Request) async throws -> Response {
        let todoId = parseToDoId(req: req);
        
        if (todoId == nil) {
            return req.redirect(to: "/todos");
        }
        
        // get the todo
        let todo = try await Todo.find(todoId!, on: req.db);
        
        // toggle the todo
        if (todo != nil) {
            todo!.done = !todo!.done;
            try await todo!.update(on: req.db);
        }
        
        return req.redirect(to: "/todos");
    }
    
    /**
     * This method parses the ToDo ID from the request.
     * it return nil if ID is not valid.
     *
     * returns: UUID?.
     *
     */
    func parseToDoId(req: Request) -> UUID? {
        guard let todoId = req.parameters.get("todoId") else {
            return nil;
        }
        
        return (UUID(uuidString: todoId));
    }
}

func parseSortType(req: Request) -> String? {
    guard let sortType = req.query[String.self, at: "sort"] else {
        return nil;
    }

    if (sortType != "desc" && sortType != "asc" && sortType != "status") {
        return nil;
    }
    
    return sortType;
}

func sortItems(todos: [Todo], sortType: String) throws -> [Todo] {
    if (sortType != "desc" && sortType != "asc" && sortType != "status") {
        throw Abort(.internalServerError);
    }
    
    if (sortType == "desc") {
        return todos.sorted(by: { $0.title > $1.title });
    }
    
    if (sortType == "asc") {
        return todos.sorted(by: { $0.title < $1.title });
    }
    
    if (sortType == "status") {
        return todos.sorted(by: { $0.done && !$1.done });
    }
    
    // if we somehow get here, return the original array.
    return todos;
}

