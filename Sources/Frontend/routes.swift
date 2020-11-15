import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "This is frontend"
    }

    // try app.register(collection: TodoController())
}
