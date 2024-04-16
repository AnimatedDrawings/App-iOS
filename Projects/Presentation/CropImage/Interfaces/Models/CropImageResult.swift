//
//  CropImageResult.swift
//  CropImageFeatures
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import DomainModels
import UIKit
import ADResources

public struct CropImageResult: Equatable {
  public let image: UIImage
  public let boundingBox: BoundingBox
  
  public init(image: UIImage, boundingBox: BoundingBox) {
    self.image = image
    self.boundingBox = boundingBox
  }
}

public extension CropImageResult {
  static func mock() -> Self {
    let image = ADResourcesAsset.TestImages.croppedImage.image
    return .init(image: image, boundingBox: .mock())
  }
}
