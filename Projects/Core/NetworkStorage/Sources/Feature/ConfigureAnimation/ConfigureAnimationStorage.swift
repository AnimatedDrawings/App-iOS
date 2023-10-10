//
//  ConfigureAnimationStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

class ConfigureAnimationStorage {
  let storage = NetworkStorage<ConfigureAnimationTargetType>()
  
  static let shared = ConfigureAnimationStorage()
  
  @Sendable
  func add(request: ConfigureAnimationRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.add(request))
    return response
  }
  
  // response 감싸기
  @Sendable
  func downloadGIF(request: ConfigureAnimationRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.add(request))
    return response
  }
}

class _MakeADStorage {
  let storage = NetworkStorage<MakeADTargetType>()
  
  static let shared = MakeADStorage()

  @Sendable
  func uploadDrawing(request: UploadADrawingRequest) async throws -> UploadADrawingResponse {
    let response: UploadADrawingResponse = try await storage.request(.uploadDrawing(request))
    return response
  }
  
  @Sendable
  func findTheCharacter(request: FindTheCharacterRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.findTheCharacter(request))
    return response
  }
  @Sendable
  func downloadMaskImage(request: FindTheCharacterRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.findTheCharacter(request))
    return response
  }
  
  @Sendable
  func separateCharacter(request: SeparateCharacterRequest) async throws -> SeparateCharacterReponse {
    let response: SeparateCharacterReponse = try await storage.request(.separateCharacter(request))
    return response
  }
  
  @Sendable
  func findCharacterJoints(request: FindCharacterJointsRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.findCharacterJoints(request))
    return response
  }
}

