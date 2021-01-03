import Vapor

public struct CreatedContainer: Content {
  let id: String
}

public struct CreateContainer: Content, Equatable {
    public struct HostConfig: Content, Equatable {
        let binds: [String]
        let portBindings: [PortBinding]
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            binds = try container.decodeIfPresent([String].self, forKey: .binds) ?? []
            
            portBindings = try container
                .decode([String: [[String: String]]].self, forKey: .portBindings)
                .compactMap { (key, value) in value.first?["hostPort"].map { PortBinding(targetPort: key, hostPort: $0) } }
                .sorted(by: { $0.hostPort > $1.hostPort })
        }

        public init(binds: [String], portBindings: [PortBinding]) {
          self.binds = binds
          self.portBindings = portBindings
        }
        
        private enum CodingKeys: String, CodingKey {
            case binds
            case portBindings
        }
    }
    
    public struct PortBinding: Content, Equatable {
        public let targetPort: String
        public let hostPort: String
    }
    
    public let image: String
    public let hostConfig: HostConfig?
    public let labels: [String: String]?
}

public enum ContainerProperty {
  public enum `Protocol` {
    case udp
    case tcp
  }

  case portBinding(protocol: `Protocol`, host: Int, target: Int)
}