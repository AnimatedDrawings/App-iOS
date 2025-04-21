import Foundation

public protocol ADNetworkStorageProtocol {
  func uploadDrawing(request: UploadDrawingRequest)
    async -> Result<UploadDrawingResponseDTO, NetworkStorageError>
  func findCharacter(request: FindCharacterRequest)
    async -> Result<FindCharacterResponseDTO, NetworkStorageError>
  func cutoutCharacter(request: CutoutCharacterRequest)
    async -> Result<CutoutCharacterResponseDTO, NetworkStorageError>
  func configureCharacterJoints(request: ConfigureCharacterJointsRequest)
    async -> Result<ADEmptyResponse, NetworkStorageError>
  func makeAnimation(request: MakeAnimationRequest)
    async -> Result<any WebSocketManagerProtocol, WebSocketError>
  func downloadAnimation(request: DownloadAnimationRequest)
    async -> Result<DownloadAnimationResponseDTO, NetworkStorageError>
}
