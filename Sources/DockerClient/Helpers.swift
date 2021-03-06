import Foundation
import Vapor

public enum DockerArgument {
  case all(Bool)
  case filters([DockerFilter])
  case name(String)

  var key: String {
    switch self {
      case .all: return "all"
      case .filters: return "filters"
      case .name: return "name"
    }
  }

  var value: String {
    switch self {
      case .all(let v): return "\(v)"
      case .filters(let filters):  return "{\(filters.map { "\($0.key):\($0.value)" }.joined(separator: ","))}"
      case .name(let name): return name
    }
  }
}

public enum DockerFilter {
  case ancestor(String)
  case isTask(Bool)

    var key: String {
    switch self {
      case .ancestor: return "\"ancestor\""
      case .isTask: return "\"is-task\""
    }
  }

  var value: String {
    switch self {
      case .ancestor(let v): return "[\"\(v)\"]"
      case .isTask(let v): return "[\"\(v)\"]"
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