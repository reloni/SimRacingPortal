import Vapor

public class DockerClient {
    let httpClient: Client

    public init(httpClient: Client) {
        self.httpClient = httpClient
    }

    public func runningContainers() -> EventLoopFuture<[DockerContainer]> {
        httpClient.get("http://localhost:15432/containers/json").flatMapThrowing { res in
            return try res.content.decode([DockerContainer].self, using: DockerJSONDecoder())
        }
    }
}