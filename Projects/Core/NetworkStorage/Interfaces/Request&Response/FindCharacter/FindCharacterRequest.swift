import CoreModels
import Foundation

public struct FindCharacterRequest: Encodable {
  public let ad_id: String
  public let boundingBoxDTO: BoundingBoxDTO

  public init(ad_id: String, boundingBoxDTO: BoundingBoxDTO) {
    self.ad_id = ad_id
    self.boundingBoxDTO = boundingBoxDTO
  }

  enum CodingKeys: String, CodingKey {
    case ad_id
    case boundingBoxDTO = "bounding_box"
  }
}
