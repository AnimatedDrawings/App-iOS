//
//  MakeADStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public class MakeADStorage {
  private let storage = NetworkStorage<MakeADTargetType>()
  
  public static let shared = MakeADStorage()

  public func uploadDrawing(request: UploadADrawingRequest) async throws -> UploadADrawingResponse {
    let response: UploadADrawingResponse = try await storage.request(.uploadDrawing(request))
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
  
  public func separateCharacter(request: SeparateCharacterRequest) async throws -> SeparateCharacterReponse {
    let response: SeparateCharacterReponse = try await storage.request(.separateCharacter(request))
    return response
  }
  
  public func findCharacterJoints(request: FindCharacterJointsRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.findCharacterJoints(request))
    return response
  }
}
