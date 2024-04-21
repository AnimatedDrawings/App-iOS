//
//  ConfigureAnimationStorageProtocol.swift
//  NetworkStorageInterfaces
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import CoreModels

public protocol ConfigureAnimationStorageProtocol {
  func add(request: AddAnimationRequest) async throws -> EmptyResponse
  func download(request: DownloadAnimationRequest) async throws -> DownloadAnimationResponse
}
