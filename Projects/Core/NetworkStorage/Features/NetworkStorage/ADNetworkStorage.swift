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
  ) async -> Result<MakeAnimationResponseDTO, NetworkStorageError> {
    let result = await storage.download(.makeAnimation(request))
    switch result {
    case .success(let data):
      let response = MakeAnimationResponseDTO(animation: data)
      return .success(response)
    case .failure(let error):
      return .failure(error)
    }
  }
}
