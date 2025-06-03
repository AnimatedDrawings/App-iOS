import UIKit

public struct BoundingBoxDTO: Codable, Equatable {
  public let top: Int
  public let bottom: Int
  public let left: Int
  public let right: Int

  public init(top: Int, bottom: Int, left: Int, right: Int) {
    self.top = top
    self.bottom = bottom
    self.left = left
    self.right = right
  }

  enum CodingKeys: String, CodingKey {
    case top
    case bottom
    case left
    case right
  }
}

extension BoundingBoxDTO {
  public static func mock() -> Self {
    let data = """
              {
                "bottom": 987,
                "left": 104,
                "right": 835,
                "top": 105
              }
      """.data(using: .utf8)!

    let decoded = try! JSONDecoder().decode(Self.self, from: data)
    return decoded
  }

  public static func example1() -> Self {
    return Self(top: 118, bottom: 402, left: 88, right: 264)
  }
}
