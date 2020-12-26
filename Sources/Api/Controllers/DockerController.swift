import Vapor
import DockerClient

struct Server: Content {
    let name: String
    let version: String
    let port: Int
    let track: String
}

struct CreateServerRequest: Decodable {
    let name: String
    let track: String
}

struct CreateDockerImageRequest: Encodable {
    let image: String
}

struct DockerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("docker")
        group.get("list", use: listDockerContainers)
    }

    func listDockerContainers(req: Request) throws -> EventLoopFuture<Response> {
        return req.docker
            .listContainers(.all(true), .filters([.isTask(false), .ancestor("nginx:alpine")]))
            .encodeResponse(for: req)
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