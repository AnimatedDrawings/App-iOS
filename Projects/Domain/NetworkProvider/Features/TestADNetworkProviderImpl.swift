//
//  TestADNetworkProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import ADErrors
import CoreModels
import DomainModels
import Foundation
import NetworkProviderInterfaces
import NetworkStorage
import UIKit
import ADUIKit


public class TestADNetworkProviderImpl: ADNetworkProviderProtocol {
  public init() {}
  
  public func uploadDrawing(
    image: Data
  )
  async throws -> UploadDrawingResponse
  {
    try await Task.sleep(seconds: 2)
    return .mock()
  }
  
  public func findCharacter(
    ad_id: String, boundingBox: BoundingBox
  ) async throws -> FindCharacterResponse {
    try await Task.sleep(seconds: 2)
    return .mock()
  }
  
  public func cutoutCharacter(
    ad_id: String, maskedImage: Data
  ) async throws -> CutoutCharacterResponse {
    try await Task.sleep(seconds: 2)
    return .mock()
  }
  
  public func configureCharacterJoints(
    ad_id: String, joints: Joints
  ) async throws {
    try await Task.sleep(seconds: 2)
    return
  }
  
  public func makeAnimation(
    ad_id: String, animation: ADAnimation
  ) async throws -> MakeAnimationResponse {
    try await Task.sleep(seconds: 2)
    return .mock()
  }
}
