import ADAlamofire
import Foundation
import NetworkRepositoryInterfaces

public class ADNetworkRepository: ADNetworkRepositoryProtocol {
  let networkRepository = NetworkRepository<ADTargetType>()
  
  public init() {}
  
  public func uploadDrawing(
    request: UploadDrawingRequest
  ) async -> Result<UploadDrawingResponseDTO, NetworkRepositoryError> {
    return await networkRepository.uploadImage(
      with: request.convertedPNG,
      target: .uploadDrawing(request)
    )
  }
  
  public func findCharacter(
    request: FindCharacterRequest
  ) async -> Result<FindCharacterResponseDTO, NetworkRepositoryError> {
    let result = await networkRepository.download(.findCharacter(request))
    switch result {
    case .success(let data):
      let response = FindCharacterResponseDTO(image: data)
      return .success(response)
    case .failure(let error):
      return .failure(error)
    }
  }
  
  public func cutoutCharacter(
    request: CutoutCharacterRequest
  ) async -> Result<CutoutCharacterResponseDTO, NetworkRepositoryError> {
    return await networkRepository.uploadImage(
      with: request.cutoutImageData,
      target: .cutoutCharacter(request)
    )
  }
  
  public func configureCharacterJoints(
    request: ConfigureCharacterJointsRequest
  ) async -> Result<ADEmptyResponse, NetworkRepositoryError> {
    return await networkRepository.request(.configureCharacterJoints(request))
  }
  
  public func makeAnimation(
    request: MakeAnimationRequest
  ) async -> Result<any WebSocketManagerProtocol, WebSocketError> {
    do {
      let webSocket = try WebSocketManager(ADTargetType.makeAnimation(request))
      return .success(webSocket)
    } catch let error as WebSocketError {
      return .failure(error)
    } catch {
      return .failure(.unknown)
    }
  }
  
  public func downloadAnimation(
    request: DownloadAnimationRequest
  ) async -> Result<DownloadAnimationResponseDTO, NetworkRepositoryError> {
    let result = await networkRepository.download(.downloadAnimation(request))
    switch result {
    case .success(let data):
      let response = DownloadAnimationResponseDTO(animation: data)
      return .success(response)
    case .failure(let error):
      return .failure(error)
    }
  }
}
