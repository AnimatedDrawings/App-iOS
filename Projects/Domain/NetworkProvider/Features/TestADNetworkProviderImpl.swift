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
    ad_id: String, joints: Joints
  ) async throws {
    try await Task.sleep(seconds: 0.5)

    print("--------------------------------")
    print("TEST: configureCharacterJoints")
    print("--------------------------------")

    return
  }

  public func makeAnimation(
    ad_id: String, animation: ADAnimation
  ) async throws -> MakeAnimationResponse {
    try await Task.sleep(seconds: 0.5)

    print("--------------------------------")
    print("TEST: makeAnimation")
    print("--------------------------------")

    return .mock()
  }
}
