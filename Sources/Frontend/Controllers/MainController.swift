import Vapor
import Leaf

struct MainController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.get(use: homeView)
    }
    
    func homeView(req: Request) throws -> EventLoopFuture<View> {
        return req.leaf.render("index", [
            "title": "myPage - Home",
            "data": "Hi there, welcome to my awesome page!",
        ])
    }
}