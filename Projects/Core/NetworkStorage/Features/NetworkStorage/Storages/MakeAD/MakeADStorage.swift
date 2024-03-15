//
//  MakeADStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces
import CoreModels

public class MakeADStorage: MakeADStorageProtocol {
  private let storage = NetworkStorage<MakeADTargetType>()
  
  public init() {}

  public func uploadDrawing(request: UploadDrawingRequest) async throws -> UploadDrawingResponseDTO {
    let response: UploadDrawingResponseDTO = try await storage.request(.uploadDrawing(request))
    return response
  }
  
  public func findTheCharacter(request: FindTheCharacterRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.findTheCharacter(request))
    return response
  }
  
  public func downloadMaskImage(request: DownloadMaskImageRequest) async throws -> Data {
    let response: Data = try await storage.download(.downloadMaskImage(request))
    return response
  }
  
  public func separateCharacter(request: SeparateCharacterRequest) async throws -> SeparateCharacterResponseDTO {
    let response: SeparateCharacterResponseDTO = try await storage.request(.separateCharacter(request))
    return response
  }
  
  public func findCharacterJoints(request: FindCharacterJointsRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.findCharacterJoints(request))
    return response
  }
}
