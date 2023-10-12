import Fluent
import Vapor

final class Todo: Model, Content {
    
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "done")
    var done: Bool
    
    init() { }
    
    init(id: UUID? = nil, title: String, done: Bool) {
        self.id = id
        self.title = title
        self.done = done
    }
}
