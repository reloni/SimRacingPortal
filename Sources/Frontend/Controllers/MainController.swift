import Vapor
import Leaf
import Shared

struct MainController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.get("servers", use: serversView)
        routes.post("servers", use: postServersView)
    }
    
    func serversView(req: Request) throws -> EventLoopFuture<View> {
        return req.client
            .get(ApiUri.dockerList.url)
            .flatMapThrowing { res in try res.content.decode([DockerContainer].self) }
            .map { containers in ServersViewContext("Server management", containers) }
            .flatMap { req.leaf.render("servers", $0) }
    }

    func postServersView(req: Request) throws -> EventLoopFuture<Response> {
        fatalError()

        // let body = try req.content.decode(CreateServerRequest.self)

        // return req.client.post("http://localhost:15432/containers/create", headers: ["content-type": "application/json"]) { r in 
        //     try r.query.encode(["name": body.name])
        //     r.body = try "{ \"image\": \"nginx\" }".asJsonData()?.asByteBuffer()
        // }.flatMap { _ in 
        //     let servers: [Server] = [.init(name: body.name, version: "1.6.5", port: 9001, track: body.track),]
        //     let context = ServersViewContext.init(title: "Server management", servers: servers)

        //     return req.leaf.render("servers", context).encodeResponse(for: req)
        // }
        
        // return req.eventLoop.future(req.redirect(to: "/servers"))

        // let servers: [Server] = [
        //     .init(name: "Serv 1", version: "1.6.5", port: 9001, track: "Imola"),
        //     .init(name: "Serv 2", version: "1.6.5", port: 9002, track: "Barcelona"),
        //     .init(name: "Serv 3", version: "1.6.5", port: 9003, track: "Misano"),
        //     .init(name: "Serv 5", version: "1.6.5", port: 9004, track: "Suzuka"),
        //     .init(name: "Serv 6", version: "1.6.5", port: 9005, track: "Zandvoort")
        // ]
        // let context = ServersViewContext.init(title: "Server management", servers: servers)

        // return req.leaf.render("servers", context).encodeResponse(for: req)
    }

    // func listDockerContainers(req: Request) throws -> EventLoopFuture<Response> {
    //     return req.docker.listContainers().encodeResponse(for: req)
    //     // return req.client.get("http://localhost.charlesproxy.com:15432/containers/json").encodeResponse(for: req)
    // }

    // func createContainer(req: Request) throws -> EventLoopFuture<Response> {
    //     // print(req.body.data.)
    //     return req.client.post("http://localhost.charlesproxy.com:15432/containers/create", headers: ["content-type": "application/json"]) { r in 
    //         try r.query.encode(["name": "new_server-2"])
    //         // r.body = try "{ \"image\": \"nginx\" }".asJsonData()?.asByteBuffer()
    //         r.body = req.body.data
    //     }.encodeResponse(for: req)
    // }
}