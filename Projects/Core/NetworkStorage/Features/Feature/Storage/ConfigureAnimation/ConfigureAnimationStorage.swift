//
//  ConfigureAnimationStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public class ConfigureAnimationStorage {
  private let storage = NetworkStorage<ConfigureAnimationTargetType>()
  
  public static let shared = ConfigureAnimationStorage()
  
  public func add(request: AddAnimationRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.add(request))
    return response
  }
  
  public func download(request: DownloadAnimationRequest) async throws -> Data {
    let response: Data = try await storage.download(.download(request))
    return response
  }
}
