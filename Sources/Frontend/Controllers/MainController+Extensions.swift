import Vapor
import Shared

extension MainController {
    struct ServersViewContext: ViewContext {
        let title: String
        let servers: [Server]

        init(title: String, servers: [Server]) {
            self.title = title
            self.servers = servers
        }

        init(_ title: String, _ dockerContainers: [DockerContainer]) {
            self.title = title
            self.servers = dockerContainers.map { 
                Server.init(name: $0.names.first ?? "", 
                            version: "1", 
                            port: 1, 
                            track: $0.labels["track"] ?? "",
                            state: $0.state.rawValue) 
            }
        }
    }

    struct Server: Content {
        let name: String
        let version: String
        let port: Int
        let track: String
        let state: String
    }

    struct CreateServerRequest: Decodable {
        let name: String
        let track: String
    }

    struct CreateDockerImageRequest: Encodable {
        let image: String
    }
}