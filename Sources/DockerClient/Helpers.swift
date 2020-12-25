import Foundation

public enum DockerParameter: Encodable {
  case all(Bool)

  public func encode(to encoder: Encoder) throws {    
    var container = encoder.container(keyedBy: CustomCodingKey.self)
    switch self {
      case .all(let v): try container.encode(v, forKey: CustomCodingKey.init(stringValue: "all")!)
    }
  }
}

struct CustomCodingKey: CodingKey {
  var stringValue: String

  init?(stringValue: String) {
    self.stringValue = stringValue
  }

  var intValue: Int? { 
    return nil 
  }

  init?(intValue: Int) {
    return nil
  }
}

class DockerJSONDecoder: JSONDecoder {
  override init() {
    super.init()
      keyDecodingStrategy = .custom { keys in
          let lastComponent = keys.last!.stringValue.lowercasingFirst
          return CustomCodingKey(stringValue: lastComponent)!
      }
  }
}