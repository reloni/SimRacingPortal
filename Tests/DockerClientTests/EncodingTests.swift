@testable import DockerClient
import Vapor
import XCTVapor

final class EncodingTests: XCTestCase {
    var jsonDir: String {
        "\(DirectoryConfiguration.detect().workingDirectory)/Tests/DockerClientTests/json"
    }

    func testDecodeCreateContainer() throws {
        let jsonRaw = try! Data(contentsOf: URL(fileURLWithPath: "\(jsonDir)/testDecodeCreateContainer.json"))
        let body = try! JSONDecoder().decode(CreateContainer.self, from: jsonRaw)
        
        let comparison = CreateContainer.init(image: "nginx:alpine", 
                                              hostConfig: .init(
                                                  binds: ["/Users/AntonEfimenko/_tempdel/accserverexample:/accserver"],
                                                  portBindings: [
                                                    .init(targetPort: "9232/tcp", hostPort: "9232"),
                                                    .init(targetPort: "9231/udp", hostPort: "9231")
                                                  ]),
                                                  labels: ["track": "test"])

        XCTAssertEqual(body, comparison)
    }
}

