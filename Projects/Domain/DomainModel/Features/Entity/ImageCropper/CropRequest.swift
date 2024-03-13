//
//  CropRequest.swift
//  ImageCompressor
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADUIKitResources

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
    let example1: UIImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
    let viewBoundingBox = CGRect(x: 10, y: 10, width: 100, height: 100)
    
    return Self(
      imageScale: imageScale,
      viewBoundingBox: viewBoundingBox,
      originalImage: example1
    )
  }
}
