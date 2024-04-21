//
//  MockConfigureAnimationStorage.swift
//  NetworkProviderTestings
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces
import DomainModels

public final class MockConfigureAnimationStorage: ConfigureAnimationStorageProtocol {
  public init() {}
  
  public func add(request: AddAnimationRequest) async throws -> EmptyResponse {
    return .init()
  }
  
  public func download(request: DownloadAnimationRequest) async throws -> DownloadAnimationResponse {
    return .init(animation: Data())
  }
}
