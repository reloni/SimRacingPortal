import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // print(app.directory.viewsDirectory)
    // print(app.directory.workingDirectory)
    // var a = app.leaf.renderer.configuration
    // print(a.rootDirectory)
    if !app.environment.isRelease {
        app.leaf.cache.isEnabled = false
    }
    
    app.views.use(.leaf)
    // register routes
    try routes(app)
}
