//
//  ConfigureAnimationProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import NetworkProviderInterfaces
import DomainModels
import NetworkStorage

public final class ConfigureAnimationProviderImpl: ConfigureAnimationProviderProtocol {
  let storage: ConfigureAnimationStorageProtocol
  
  public init(storage: ConfigureAnimationStorageProtocol = ConfigureAnimationStorage()) {
    self.storage = storage
  }
  
  public func add(ad_id: String, animation: ADAnimation) async throws {
    let request = AddAnimationRequest(ad_id: ad_id, animationInfo: .init(name: animation.rawValue))
    let _ = try await storage.add(request: request)
  }
  
  public func download(ad_id: String, animation: ADAnimation) async throws -> (DownloadAnimationResponse) {
    let request = DownloadAnimationRequest(ad_id: ad_id, animationInfo: .init(name: animation.rawValue))
    let response = try await storage.download(request: request)
    return .init(animation: response.animation)
  }
}
