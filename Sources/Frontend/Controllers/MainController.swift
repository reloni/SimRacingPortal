import Vapor
import Leaf

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
        return req.leaf.render("servers", [
            "title": "Active servers"
        ])
    }
}