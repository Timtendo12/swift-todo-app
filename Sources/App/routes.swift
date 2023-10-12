import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: TodoController());
    
    // index, return index.leaf
    app.get { req async throws -> Response in
        return req.redirect(to: "/todos");
    }
    
}
