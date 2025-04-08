//
//  ADNetworkProviderProtocol.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import DomainModels
import Foundation
import NetworkStorageInterfaces

public protocol ADNetworkProviderProtocol {
  func uploadDrawing(
    image: Data
  )
    async throws -> UploadDrawingResponse

  func findCharacter(
    ad_id: String, boundingBox: BoundingBox
  ) async throws -> FindCharacterResponse

  func cutoutCharacter(
    ad_id: String, maskedImage: Data
  ) async throws -> CutoutCharacterResponse

  func configureCharacterJoints(
    ad_id: String, joints: Joints
  ) async throws

  func getWebSocketMakeAnimation(
    ad_id: String,
    animation: ADAnimation
  ) async throws -> WebSocketManagerProtocol
  
  func messagesMakeAnimation(
    webSocket: WebSocketManagerProtocol
  )
  async -> AsyncStream<MakeAnimationResponse>

  func downloadAnimation(
    ad_id: String,
    animation: ADAnimation
  ) async throws -> DownloadAnimationResponse
}
