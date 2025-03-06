import Foundation

public struct MakeAnimationRequest: Encodable {
  public let ad_id: String
  public let adAnimation: String

  public init(ad_id: String, adAnimation: String) {
    self.ad_id = ad_id
    self.adAnimation = adAnimation
  }

  enum CodingKeys: String, CodingKey {
    case ad_id
    case adAnimation = "ad_animation"
  }
}
