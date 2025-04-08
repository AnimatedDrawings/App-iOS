//
//  TestADNetworkProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import ADErrors
import ADUIKit
import CoreModels
import DomainModels
import Foundation
import NetworkProviderInterfaces
import NetworkStorage
import UIKit

public class TestADNetworkProviderImpl: ADNetworkProviderProtocol {
  public init() {}

  public func uploadDrawing(
    image: Data
  )
    async throws -> UploadDrawingResponse
  {
    try await Task.sleep(seconds: 0.5)

    print("--------------------------------")
    print("TEST: uploadDrawing")
    print("--------------------------------")

    return .example1()
  }

  public func findCharacter(
    ad_id: String, boundingBox: BoundingBox
  ) async throws -> FindCharacterResponse {
    try await Task.sleep(seconds: 0.5)

    print("--------------------------------")
    print("TEST: findCharacter")
    print("--------------------------------")

    return .example1()
  }

  public func cutoutCharacter(
    ad_id: String, maskedImage: Data
  ) async throws -> CutoutCharacterResponse {
    try await Task.sleep(seconds: 0.5)

    print("--------------------------------")
    print("TEST: cutoutCharacter")
    print("--------------------------------")

    return .example1()
  }

  public func configureCharacterJoints(
    ad_id: String,
    joints: Joints
  ) async throws {
    try await Task.sleep(seconds: 0.5)

    print("--------------------------------")
    print("TEST: configureCharacterJoints")
    print("--------------------------------")

    return
  }
  
  public func getWebSocketMakeAnimation(
    ad_id: String,
    animation: ADAnimation
  ) async throws -> WebSocketManagerProtocol
  {
    print("--------------------------------")
    print("TEST: getWebSocketMakeAnimation")
    print("--------------------------------")
    return MockWebSocketManager()
  }
  
  public func messagesMakeAnimation(
    webSocket: WebSocketManagerProtocol
  )
  async -> AsyncStream<MakeAnimationResponse>
  {
    print("--------------------------------")
    print("TEST: messagesMakeAnimation")
    print("--------------------------------")
    return AsyncStream<MakeAnimationResponse> { continuation in
      Task {
        for _ in 0..<3 {
          continuation.yield(MakeAnimationResponse.running())
          try await Task.sleep(seconds: 1)
        }
        continuation.yield(MakeAnimationResponse.complete())
        continuation.finish()
      }
    }
  }

  public func downloadAnimation(
    ad_id: String,
    animation: ADAnimation
  ) async throws -> DownloadAnimationResponse {
    try await Task.sleep(seconds: 0.5)

    print("--------------------------------")
    print("TEST: downloadAnimation")
    print("--------------------------------")

    return .example1Dab()
  }
}
