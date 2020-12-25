import Vapor

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

    public func listContainers(_ parameters: DockerParameter...) -> EventLoopFuture<[DockerContainer]> {
        httpClient.get("http://localhost:15432/containers/json") { req in 
            try parameters.forEach { try req.query.encode($0) }
        }.flatMapThrowing { res in
            return try res.content.decode([DockerContainer].self, using: DockerJSONDecoder())
        }
    }
}