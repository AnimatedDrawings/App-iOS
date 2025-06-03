import Foundation

public struct CutoutCharacterRequest {
  public let ad_id: String
  public let cutoutImageData: Data

  public init(ad_id: String, cutoutImageData: Data) {
    self.ad_id = ad_id
    self.cutoutImageData = cutoutImageData
  }
}
