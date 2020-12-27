import Vapor

enum ApiUri {
    static let base: URI = {
        "\(Environment.EnvVar.apiProtocol.value!)://\(Environment.EnvVar.apiHost.value!):\(Environment.EnvVar.apiPort.value!)"
    }()

    case dockerList

    var url: URI {
        switch self {
            case .dockerList: return "\(Self.base)/docker/list"
        }
    }
}