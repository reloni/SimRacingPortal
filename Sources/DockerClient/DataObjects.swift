import Vapor

public struct DockerContainer: Content {
    public let id: String
    public let names: [String]
    public let image: String
}