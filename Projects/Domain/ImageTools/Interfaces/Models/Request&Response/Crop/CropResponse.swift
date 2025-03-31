//
//  CropResponse.swift
//  ImageToolsInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADResources
import DomainModels

public struct CropResponse: Equatable {
  public let image: UIImage
  public let boundingBox: CGRect
  
  public init(image: UIImage, boundingBox: CGRect) {
    self.image = image
    self.boundingBox = boundingBox
  }
}

public extension CropResponse {
  static func mock() -> Self {
    let image: UIImage = ADResourcesAsset.GarlicTestImages.croppedImage.image
    return Self(
      image: image,
      boundingBox: BoundingBox.mock().cgRect
    )
  }
}
