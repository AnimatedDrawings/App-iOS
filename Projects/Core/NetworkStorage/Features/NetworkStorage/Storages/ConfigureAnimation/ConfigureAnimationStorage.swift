//
//  ConfigureAnimationStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import CoreModels
import NetworkStorageInterfaces

public class ConfigureAnimationStorage: ConfigureAnimationStorageProtocol {
  private let storage = NetworkStorage<ConfigureAnimationTargetType>()
  
  public init() {}
  
  public func add(request: AddAnimationRequest) async throws -> EmptyResponse {
    let response: EmptyResponse = try await storage.request(.add(request))
    return response
  }
  
  public func download(request: DownloadAnimationRequest) async throws -> DownloadAnimationResponse {
    let response: Data = try await storage.download(.download(request))
    return .init(animation: response)
  }
}
