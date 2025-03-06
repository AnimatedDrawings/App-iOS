import Foundation

public struct FindCharacterResponseDTO: Decodable {
  public let image: Data

  public init(image: Data) {
    self.image = image
  }
}
