//
//  TestMakeADProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import NetworkProviderInterfaces
import NetworkStorageInterfaces
import NetworkStorage
import DomainModels
import ADResources
import Foundation

final public class TestMakeADProviderImpl: MakeADProviderProtocol {
  public func uploadDrawing(image: Data) async throws -> UploadDrawingResponse {
    return .mock()
  }
  
  public func findTheCharacter(ad_id: String, boundingBox: BoundingBox) async throws {}
  
  public func downloadMaskImage(ad_id: String) async throws -> DownloadMaskImageResponse {
    return .mock()
  }
  
  public func separateCharacter(ad_id: String, maskedImage: Data) async throws -> SeparateCharacterResponse {
    return .init(joints: Joints.mockExample2())
  }
  
  public func findCharacterJoints(ad_id: String,joints: Joints) async throws {}
}
