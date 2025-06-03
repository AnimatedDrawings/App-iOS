import Foundation

public struct ConfigureCharacterJointsRequest: Encodable {
  public let ad_id: String
  public let jointsDTO: JointsDTO

  public init(ad_id: String, jointsDTO: JointsDTO) {
    self.ad_id = ad_id
    self.jointsDTO = jointsDTO
  }

  enum CodingKeys: String, CodingKey {
    case ad_id
    case jointsDTO = "joints"
  }
}
