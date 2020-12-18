import Vapor
import Leaf

protocol ViewContext: Content {
    var title: String { get }
}

struct Server: Content {
    let name: String
    let version: String
    let port: Int
    let track: String
}

struct ServersViewContext: ViewContext {
    let title: String
    let servers: [Server]
}

struct MainController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.get(use: homeView)
        routes.get("servers", use: serversView)
    }
    
    func homeView(req: Request) throws -> EventLoopFuture<View> {
        return req.leaf.render("index", [
            "title": "myPage - Home",
            "header": "Page header",
        ])
    }

    func serversView(req: Request) throws -> EventLoopFuture<View> {
        let servers: [Server] = [
            .init(name: "Serv 1", version: "1.6.5", port: 9001, track: "Imola"),
            .init(name: "Serv 2", version: "1.6.5", port: 9002, track: "Barcelona"),
            .init(name: "Serv 3", version: "1.6.5", port: 9003, track: "Misano"),
            .init(name: "Serv 5", version: "1.6.5", port: 9004, track: "Suzuka"),
            .init(name: "Serv 6", version: "1.6.5", port: 9005, track: "Zandvoort")
        ]
        let context = ServersViewContext.init(title: "Server management", servers: servers)

        return req.leaf.render("servers", context)
    }
}