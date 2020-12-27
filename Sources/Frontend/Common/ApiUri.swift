import Vapor

enum ApiUri {
    static let base: URI = {
        "\(Environment.process.API_PROTOCOL!)://\(Environment.process.API_HOST!):\(Environment.process.API_PORT!)"
    }()

    case dockerList

    var url: URI {
        switch self {
            case .dockerList: return "\(Self.base)/docker/list"
        }
    }
}