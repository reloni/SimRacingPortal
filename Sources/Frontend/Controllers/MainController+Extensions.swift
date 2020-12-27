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
                let properties: [KeyValuePair<String, String>] = [
                    .init(key: "Version", value: $0.image),
                    .init(key: "Port", value: "1234"),
                    .init(key: "State", value: $0.state.rawValue),
                    .init(key: "Track", value: $0.labels["track"] ?? "")
                ]
                return Server.init(name: $0.names.first ?? "", 
                            version: "1", 
                            port: 1, 
                            track: $0.labels["track"] ?? "",
                            state: $0.state.rawValue, 
                            properties: properties) 
            }
        }
    }

    struct Server: Content {
        let name: String
        let version: String
        let port: Int
        let track: String
        let state: String
        let properties: [KeyValuePair<String, String>]
    }

    struct CreateServerRequest: Decodable {
        let name: String
        let track: String
    }

    struct CreateDockerImageRequest: Encodable {
        let image: String
    }
}