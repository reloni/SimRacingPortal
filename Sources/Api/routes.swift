import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "This is api"
    }

    // try app.register(collection: TodoController())
}
