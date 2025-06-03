import Foundation

public protocol ADNetworkRepositoryProtocol {
  func uploadDrawing(request: UploadDrawingRequest)
    async -> Result<UploadDrawingResponseDTO, NetworkRepositoryError>
  func findCharacter(request: FindCharacterRequest)
    async -> Result<FindCharacterResponseDTO, NetworkRepositoryError>
  func cutoutCharacter(request: CutoutCharacterRequest)
    async -> Result<CutoutCharacterResponseDTO, NetworkRepositoryError>
  func configureCharacterJoints(request: ConfigureCharacterJointsRequest)
    async -> Result<ADEmptyResponse, NetworkRepositoryError>
  func makeAnimation(request: MakeAnimationRequest)
    async -> Result<any WebSocketManagerProtocol, WebSocketError>
  func downloadAnimation(request: DownloadAnimationRequest)
    async -> Result<DownloadAnimationResponseDTO, NetworkRepositoryError>
}
