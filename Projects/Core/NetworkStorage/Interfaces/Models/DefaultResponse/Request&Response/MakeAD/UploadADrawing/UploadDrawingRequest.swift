//
//  UploadDrawingRequest.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct UploadDrawingRequest {
  public let convertedPNG: Data
  
  public init(convertedPNG: Data) {
    self.convertedPNG = convertedPNG
  }
}
