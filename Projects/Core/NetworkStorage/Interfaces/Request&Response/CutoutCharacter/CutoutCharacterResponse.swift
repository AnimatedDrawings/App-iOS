import CoreModels
import Foundation

public struct CutoutCharacterResponse: Decodable {
  public let jointsDTO: JointsDTO

  public init(jointsDTO: JointsDTO) {
    self.jointsDTO = jointsDTO
  }

  enum CodingKeys: String, CodingKey {
    case jointsDTO = "char_cfg"
  }
}
