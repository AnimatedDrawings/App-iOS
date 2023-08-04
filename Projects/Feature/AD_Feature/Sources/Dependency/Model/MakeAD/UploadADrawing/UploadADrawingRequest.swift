//
//  UploadADrawingRequest.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct UploadADrawingRequest {
  public let originalImageData: Data
  
  public init(originalImageData: Data) {
    self.originalImageData = originalImageData
  }
}
