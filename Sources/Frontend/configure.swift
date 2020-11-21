import Vapor
import Leaf
import LeafKit

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.leaf.cache.isEnabled = app.environment.isRelease
    
    app.leaf.sources = try configureLeafSources()
    app.views.use(.leaf)
    
    try routes(app)
}

func configureLeafSources() throws -> LeafSources {
    let sources = LeafSources()
    
    let defaultSource = NIOLeafFiles(fileio: app.fileio, 
                                    limits: .default, 
                                    sandboxDirectory: app.directory.workingDirectory, 
                                    viewDirectory: app.directory.viewsDirectory, 
                                    defaultExtension: "leaf")
    let frontendSource = NIOLeafFiles(fileio: app.fileio, 
                                    limits: .default, 
                                    sandboxDirectory: app.directory.workingDirectory, 
                                    viewDirectory: "\(app.directory.viewsDirectory)/Frontend", 
                                    defaultExtension: "leaf")
    
    try sources.register(using: defaultSource)
    try sources.register(source: "Frontend", using: frontendSource, searchable: true)

    return sources
}
