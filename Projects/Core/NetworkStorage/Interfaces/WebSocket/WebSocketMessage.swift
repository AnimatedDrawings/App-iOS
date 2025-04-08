import Foundation

public struct AnyDecodable: Decodable {
  let value: Any

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if container.decodeNil() {
      value = NSNull()
    } else if let bool = try? container.decode(Bool.self) {
      value = bool
    } else if let int = try? container.decode(Int.self) {
      value = int
    } else if let double = try? container.decode(Double.self) {
      value = double
    } else if let string = try? container.decode(String.self) {
      value = string
    } else if let array = try? container.decode([AnyDecodable].self) {
      value = array.map { $0.value }
    } else if let dictionary = try? container.decode([String: AnyDecodable].self) {
      value = dictionary.mapValues { $0.value }
    } else {
      throw DecodingError.dataCorruptedError(
        in: container, debugDescription: "AnyDecodable 값을 디코딩할 수 없습니다")
    }
  }
}

public struct WebSocketMessage<T: RawRepresentable>: Decodable
where T.RawValue == String {
  public let type: T
  public let message: String?
  public let data: [String: AnyDecodable]?

  private enum CodingKeys: String, CodingKey {
    case type, message, data
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let typeString = try container.decode(String.self, forKey: .type)
    guard let decodedType = T(rawValue: typeString) else {
      throw WebSocketError.decodeMessage
    }

    type = decodedType
    message = try container.decodeIfPresent(String.self, forKey: .message)
    data = try container.decodeIfPresent([String: AnyDecodable].self, forKey: .data)
  }
}
