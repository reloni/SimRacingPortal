import Vapor

public extension Request {
    var docker: DockerClient {
        .init(host: "localhost", port: 15432, httpClient: self.client)
    }
}

extension String {
    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
}