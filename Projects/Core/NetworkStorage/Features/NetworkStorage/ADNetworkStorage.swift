import ADAlamofire
import Foundation
import NetworkStorageInterfaces

public class ADNetworkStorage: ADNetworkStorageProtocol {
  let storage = NetworkStorage<ADTargetType>()
  
  public init() {}
  
  public func uploadDrawing(
    request: UploadDrawingRequest
  ) async -> Result<UploadDrawingResponseDTO, NetworkStorageError> {
    return await storage.uploadImage(
      with: request.convertedPNG,
      target: .uploadDrawing(request)
    )
  }
  
  public func findCharacter(
    request: FindCharacterRequest
  ) async -> Result<FindCharacterResponseDTO, NetworkStorageError> {
    let result = await storage.download(.findCharacter(request))
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
  ) async -> Result<CutoutCharacterResponseDTO, NetworkStorageError> {
    return await storage.uploadImage(
      with: request.cutoutImageData,
      target: .cutoutCharacter(request)
    )
  }
  
  public func configureCharacterJoints(
    request: ConfigureCharacterJointsRequest
  ) async -> Result<ADEmptyResponse, NetworkStorageError> {
    return await storage.request(.configureCharacterJoints(request))
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
  ) async -> Result<DownloadAnimationResponseDTO, NetworkStorageError> {
    let result = await storage.download(.downloadAnimation(request))
    switch result {
    case .success(let data):
      let response = DownloadAnimationResponseDTO(animation: data)
      return .success(response)
    case .failure(let error):
      return .failure(error)
    }
  }
}
