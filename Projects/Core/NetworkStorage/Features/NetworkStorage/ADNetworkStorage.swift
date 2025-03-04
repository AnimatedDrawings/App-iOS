import ADAlamofire
import Foundation
import NetworkStorageInterfaces

public class ADNetworkStorage: ADNetworkStorageProtocol {
  let storage = NetworkStorage<ADTargetType>()
  
  public init() {}
  
  public func uploadDrawing(
    request: UploadDrawingRequest
  )
  async -> Result<UploadDrawingResponseDTO, NetworkStorageError>
  {
    return await storage.request(.uploadDrawing(request))
  }
  
  public func findCharacter(
    request: FindCharacterRequest
  ) async -> Result<FindCharacterResponseDTO, NetworkStorageError>
  {
    return await storage.request(.findCharacter(request))
  }
  
  public func cutoutCharacter(
    request: CutoutCharacterRequest)
  async -> Result<CutoutCharacterResponseDTO, NetworkStorageError>
  {
    return await storage.request(.cutoutCharacter(request))
  }
  
  public func configureCharacterJoints(
    request: ConfigureCharacterJointsRequest
  ) async -> Result<ADEmptyResponse, NetworkStorageError>
  {
    return await storage.request(.configureCharacterJoints(request))
  }
  
  public func makeAnimation(request: MakeAnimationRequest)
  async -> Result<MakeAnimationResponseDTO, NetworkStorageError>
  {
    return await storage.request(.makeAnimation(request))
  }
}
