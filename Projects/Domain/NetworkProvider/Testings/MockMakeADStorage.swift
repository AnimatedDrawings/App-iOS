//
//  MockMakeADStorage.swift
//  NetworkProviderTestings
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces
import ADResources
import CoreModels

public final class MockMakeADStorage: MakeADStorageProtocol {
  var downloadMaskImage: Data
  
  public init(downloadMaskImage: Data) {
    self.downloadMaskImage = downloadMaskImage
  }
  
  public func uploadDrawing(request: UploadDrawingRequest) async throws -> UploadDrawingResponseDTO {
    return .init(ad_id: "uploadDrawing", boundingBoxDTO: BoundingBoxDTO.mockExample2())
  }
  
  public func findTheCharacter(request: FindTheCharacterRequest) async throws -> EmptyResponse {
    return .init()
  }
  
  public func downloadMaskImage(request: DownloadMaskImageRequest) async throws -> DownloadMaskImageResponseDTO {
    return .init(image: downloadMaskImage)
  }
  
  public func separateCharacter(request: SeparateCharacterRequest) async throws -> SeparateCharacterResponseDTO {
    return .init(jointsDTO: .mock())
  }
  
  public func findCharacterJoints(request: FindCharacterJointsRequest) async throws -> EmptyResponse {
    return .init()
  }
}
