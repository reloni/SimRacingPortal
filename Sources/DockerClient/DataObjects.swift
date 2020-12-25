import Vapor

public struct DockerContainer: Content {
    public let id: String
    public let imageID: String
    public let names: [String]
    public let image: String
    public let state: ContainerState
    public let status: String
    public let command: String
}

public enum ContainerState: String, Codable {
    case created
    case restarting
    case running
    case removing
    case paused
    case exited
    case dead
}