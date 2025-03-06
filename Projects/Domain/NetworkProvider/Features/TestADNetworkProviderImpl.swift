//
//  TestADNetworkProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import DomainModels
import NetworkStorage
import NetworkProviderInterfaces
import CoreModels
import ADErrors
import UIKit

public class TestADNetworkProviderImpl: ADNetworkProviderProtocol {
  public init() {}
  
  public func uploadDrawing(
    image: Data
  )
  async throws -> UploadDrawingResponse {
    return .mock()
  }
  
  public func findCharacter(
    ad_id: String, boundingBox: BoundingBox
  ) async throws -> FindCharacterResponse {
    return .mock()
  }
  
  public func cutoutCharacter(
    ad_id: String, maskedImage: Data
  ) async throws -> CutoutCharacterResponse {
    return .mock()
  }
  
  public func configureCharacterJoints(
    ad_id: String, joints: Joints
  ) async throws {
    return
  }
  
  public func makeAnimation(
    ad_id: String, animation: ADAnimation
  ) async throws -> MakeAnimationResponse {
    return .mock()
  }
}
