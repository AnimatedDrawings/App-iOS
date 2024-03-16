//
//  UploadDrawingResult.swift
//  UploadDrawingFeatures
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import DomainModels

public struct UploadDrawingResult: Equatable {
  public let originalImage: UIImage
  public let boundingBox: BoundingBox
  
  public init(originalImage: UIImage, boundingBox: BoundingBox) {
    self.originalImage = originalImage
    self.boundingBox = boundingBox
  }
}

