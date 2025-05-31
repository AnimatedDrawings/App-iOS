import UIKit

public protocol AnimationRendererProtocol {
  func render() async throws -> AnimationGIF
}

public struct AnimationGIF {
  public let data: Data

  public init(data: Data) {
    self.data = data
  }
}
