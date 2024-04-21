//
//  MakeADProviderProtocol.swift
//  NetworkProviderInterfaces
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import DomainModels

public protocol MakeADProviderProtocol {
  func uploadDrawing(image: Data) async throws -> UploadDrawingResponse
  func findTheCharacter(ad_id: String, boundingBox: BoundingBox) async throws -> Void
  func downloadMaskImage(ad_id: String) async throws -> DownloadMaskImageResponse
  func separateCharacter(ad_id: String,maskedImage: Data) async throws -> SeparateCharacterResponse
  func findCharacterJoints(ad_id: String,joints: Joints) async throws -> Void
}
