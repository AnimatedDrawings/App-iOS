import Foundation

public struct FindCharacterResponse: Decodable {
  public let image: Data

  public init(image: Data) {
    self.image = image
  }
}
