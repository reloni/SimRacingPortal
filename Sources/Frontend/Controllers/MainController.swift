import Vapor
import Leaf
import DockerClient

extension String {
    func asJsonData() throws -> Data? {
        return try (JSONSerialization.jsonObject(with: Data(self.utf8), options: []) as? [String: AnyObject])
            .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
    }
}

extension Data {
    func asByteBuffer() -> ByteBuffer {
        var buffer = ByteBufferAllocator().buffer(capacity: count)
        buffer.writeBytes(self)
        return  buffer
    }
}

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

struct CreateServerRequest: Decodable {
    let name: String
    let track: String
}

struct CreateDockerImageRequest: Encodable {
    let image: String
}

struct MainController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.get("servers", use: serversView)
        routes.post("servers", use: postServersView)

        routes.get("docker", "list", use: listDockerContainers)
        routes.post("docker", "create", use: createContainer)
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

    func postServersView(req: Request) throws -> EventLoopFuture<Response> {
        let body = try req.content.decode(CreateServerRequest.self)

        return req.client.post("http://localhost:15432/containers/create", headers: ["content-type": "application/json"]) { r in 
            try r.query.encode(["name": body.name])
            r.body = try "{ \"image\": \"nginx\" }".asJsonData()?.asByteBuffer()
        }.flatMap { _ in 
            let servers: [Server] = [.init(name: body.name, version: "1.6.5", port: 9001, track: body.track),]
            let context = ServersViewContext.init(title: "Server management", servers: servers)

            return req.leaf.render("servers", context).encodeResponse(for: req)
        }
        
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

    func listDockerContainers(req: Request) throws -> EventLoopFuture<Response> {
        return req.docker.runningContainers().encodeResponse(for: req)
        // return req.client.get("http://localhost.charlesproxy.com:15432/containers/json").encodeResponse(for: req)
    }

    func createContainer(req: Request) throws -> EventLoopFuture<Response> {
        // print(req.body.data.)
        return req.client.post("http://localhost.charlesproxy.com:15432/containers/create", headers: ["content-type": "application/json"]) { r in 
            try r.query.encode(["name": "new_server-2"])
            // r.body = try "{ \"image\": \"nginx\" }".asJsonData()?.asByteBuffer()
            r.body = req.body.data
        }.encodeResponse(for: req)
    }
}