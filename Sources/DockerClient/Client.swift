import Vapor
import Shared

public class DockerClient {
    let baseUrl: URL
    let httpClient: Client

    public init(host: String, port: Int, httpClient: Client) {
        guard let url = URL(string: "http://\(host):\(port)") else {
            fatalError("Unable to create URL for host \(host) and port \(port)")
        } 

        self.baseUrl = url
        self.httpClient = httpClient
    }

    public func listContainers(_ arguments: DockerArgument...) -> EventLoopFuture<[DockerContainer]> {
        httpClient.get("\(baseUrl)/containers/json") { req in 
            try req.query.encode(
                arguments.reduce(into: [String: String]()) {  $0[$1.key] = $1.value }
            )
        }.flatMapThrowing { res in
            try res.content.decode([DockerContainer].self, using: DockerJSONDecoder())
        }
    }

    public func createContainer(body: CreateContainer, arguments: DockerArgument...) -> EventLoopFuture<ClientResponse> {
        // print(body.hostConfig)
        return httpClient.post("\(baseUrl)/containers/create", headers: ["content-type": "application/json"]) { req in 
            try req.query.encode(
                arguments.reduce(into: [String: String]()) {  $0[$1.key] = $1.value }
            )
            // let b = CreateContainer.init(image: "test", hostConfig: nil)
            let tttt = try JSONEncoder().encode(body)
            let str = String.init(data: tttt, encoding: .utf8)!
            print(str)
            // tttt
            // req.body = tttt
            try req.content.encode(body)
        }
        // .flatMapThrowing { res in
            // try res.content.decode(CreatedContainer.self, using: DockerJSONDecoder())
        // }
    }
}