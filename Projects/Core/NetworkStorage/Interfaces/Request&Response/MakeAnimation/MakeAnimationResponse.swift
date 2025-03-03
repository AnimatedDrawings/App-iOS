import Foundation

public struct MakeAnimationResponse: Decodable {
  public let animation: Data

  public init(animation: Data) {
    self.animation = animation
  }
}
