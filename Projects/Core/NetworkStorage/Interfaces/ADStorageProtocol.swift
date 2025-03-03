import CoreModels
import Foundation

public protocol ADStorageProtocol {
  func uploadDrawing(request: UploadDrawingRequest) async throws -> UploadDrawingResponse
  func findCharacter(request: FindCharacterRequest) async throws -> FindCharacterResponse
  func cutoutCharacter(request: CutoutCharacterRequest) async throws -> CutoutCharacterResponse
  func configureCharacterJoints(request: ConfigureCharacterJointsRequest) async throws -> EmptyResponse
  func makeAnimation(request: MakeAnimationRequest) async throws -> MakeAnimationResponse
}
