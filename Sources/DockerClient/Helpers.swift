import Foundation

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