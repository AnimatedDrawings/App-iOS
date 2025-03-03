import Foundation

public struct UploadDrawingRequest {
  public let convertedPNG: Data

  public init(convertedPNG: Data) {
    self.convertedPNG = convertedPNG
  }
}
