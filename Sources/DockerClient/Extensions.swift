import Vapor

public extension Request {
    var docker: DockerClient {
        DockerClient(httpClient: client)
    }
}

extension String {
    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
}