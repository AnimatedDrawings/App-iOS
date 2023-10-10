//
//  MakeADStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

class MakeADStorage {
  let storage = NetworkStorage<MakeADTargetType>()
  
  static let shared = MakeADStorage()

  @Sendable
  func uploadDrawing(requestModel: UploadADrawingRequest) async throws -> UploadADrawingResponse {
    let responseModel: UploadADrawingResponse = try await storage.request(.uploadDrawing(requestModel))
    return responseModel
  }
  
  @Sendable
  func findTheCharacter(requestModel: FindTheCharacterRequest) async throws -> EmptyResponse {
    let responseModel: EmptyResponse = try await storage.request(.findTheCharacter(requestModel))
    return responseModel
  }
  // response 감싸기
  @Sendable
  func downloadMaskImage(requestModel: FindTheCharacterRequest) async throws -> EmptyResponse {
    let responseModel: EmptyResponse = try await storage.request(.findTheCharacter(requestModel))
    return responseModel
  }
  
  @Sendable
  func separateCharacter(requestModel: SeparateCharacterRequest) async throws -> SeparateCharacterReponse {
    let responseModel: SeparateCharacterReponse = try await storage.request(.separateCharacter(requestModel))
    return responseModel
  }
  
  @Sendable
  func findCharacterJoints(requestModel: FindCharacterJointsRequest) async throws -> EmptyResponse {
    let responseModel: EmptyResponse = try await storage.request(.findCharacterJoints(requestModel))
    return responseModel
  }
}
