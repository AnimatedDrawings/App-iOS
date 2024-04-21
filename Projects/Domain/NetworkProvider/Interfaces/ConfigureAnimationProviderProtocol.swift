//
//  ConfigureAnimationProviderProtocol.swift
//  NetworkProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import DomainModels
import NetworkStorageInterfaces

public protocol ConfigureAnimationProviderProtocol {
  func add(ad_id: String, animation: ADAnimation) async throws -> Void
  func download(ad_id: String, animation: ADAnimation) async throws -> (DownloadAnimationResponse)
}
