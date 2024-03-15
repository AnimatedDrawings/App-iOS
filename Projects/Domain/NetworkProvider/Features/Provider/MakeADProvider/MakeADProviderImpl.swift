//
//  MakeADProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import Domain

final public class MakeADProviderImpl {
  let storage: MakeADStorageProtocol
  
  public init(storage: MakeADStorageProtocol) {
    self.storage = storage
  }
  
  public func uploadDrawing(image: Data) async throws -> UploadADrawingResult {
    let response = try await storage.uploadDrawing(
      request: UploadADrawingRequest(
        convertedPNG: image
      )
    )
    let ad_id = response.ad_id
    let boundingBox = response.boundingBoxDTO.toCGRect()
    
    return UploadADrawingResult(ad_id: ad_id, boundingBox: boundingBox)
  }
  
//  public func findTheCharacter()
}
