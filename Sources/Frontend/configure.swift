import Vapor
import Leaf
import LeafKit

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.leaf.cache.isEnabled = app.environment.isRelease

    checkEnvParameters(for: app)

    app.leaf.sources = try configureLeafSources()
    app.views.use(.leaf)
    
    try routes(app)
}

func checkEnvParameters(for app: Application) {
    let notExistedVars = Environment.EnvVar.allCases.compactMap { envVar -> String? in
        Environment.get(envVar.rawValue) == nil ? envVar.rawValue : nil
    }

    notExistedVars.forEach {
        app.logger.critical("Env var \($0) not existed")
    }

    if notExistedVars.count > 0 {
        fatalError()
    }
}

func configureLeafSources() throws -> LeafSources {
    let sources = LeafSources()
    
    let defaultSource = NIOLeafFiles(fileio: app.fileio, 
                                    limits: .default, 
                                    sandboxDirectory: app.directory.workingDirectory, 
                                    viewDirectory: app.directory.viewsDirectory, 
                                    defaultExtension: "leaf")
    
    try sources.register(using: defaultSource)

    // let frontendSource = NIOLeafFiles(fileio: app.fileio, 
    //                                 limits: .default, 
    //                                 sandboxDirectory: app.directory.workingDirectory, 
    //                                 viewDirectory: "\(app.directory.viewsDirectory)", 
    //                                 defaultExtension: "leaf")
    // try sources.register(source: "Frontend", using: frontendSource, searchable: true)

    return sources
}
