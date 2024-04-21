//
//  TestConfigureAnimationProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import NetworkProviderInterfaces
import Foundation
import DomainModels

public final class TestConfigureAnimationProviderImpl: ConfigureAnimationProviderProtocol {
  public func add(ad_id: String, animation: ADAnimation) async throws {}
  
  public func download(ad_id: String, animation: ADAnimation) async throws -> (DownloadAnimationResponse) {
    return .mock()
  }
}
