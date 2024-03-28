//
//  CropRequest.swift
//  ImageToolsInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct CropRequest {
  public let imageScale: CGFloat
  public let viewBoundingBox: CGRect
  public let originalImage: UIImage
  
  public init(imageScale: CGFloat, viewBoundingBox: CGRect, originalImage: UIImage) {
    self.imageScale = imageScale
    self.viewBoundingBox = viewBoundingBox
    self.originalImage = originalImage
  }
}

public extension CropRequest {
  static func mock() -> Self {
    let imageScale: CGFloat = 1
    let viewBoundingBox: CGRect = .init(x: 1, y: 1, width: 100, height: 100)
    let originalImage: UIImage = ADResourcesAsset.TestImages.originalImage.image
    
    return Self(
      imageScale: imageScale,
      viewBoundingBox: viewBoundingBox,
      originalImage: originalImage
    )
  }
}
