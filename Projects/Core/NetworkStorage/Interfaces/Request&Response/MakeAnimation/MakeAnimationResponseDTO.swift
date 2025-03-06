import Foundation

public struct MakeAnimationResponseDTO: Decodable {
  public let animation: Data

  public init(animation: Data) {
    self.animation = animation
  }
}
