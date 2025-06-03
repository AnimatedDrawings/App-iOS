import Foundation
import NetworkRepositoryInterfaces
import ADAlamofire

extension Encodable {
  func toDict() throws -> Parameters {
    let error = NetworkRepositoryError.toDictionary

    guard let data = try? JSONEncoder().encode(self)
    else {
      throw error
    }
    guard
      let anyDict = try? JSONSerialization.jsonObject(
        with: data,
        options: .allowFragments
      ) as? [String: Any]
    else {
      throw error
    }
    
    return anyDict
  }
}

extension Parameters {
  func toStringValue() -> [String: String] {
    var stringDict: [String: String] = [:]
    for (key, value) in self {
      if let strValue = value as? String {
        stringDict[key] = strValue
      } else {
        stringDict[key] = String(describing: value)
      }
    }
    return stringDict
  }
}
