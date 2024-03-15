//
//  CropResult.swift
//  ImageCompressor
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct CropResult: Equatable {
  public let image: UIImage
  public let boundingBox: CGRect
  
  public init(image: UIImage, boundingBox: CGRect) {
    self.image = image
    self.boundingBox = boundingBox
  }
}

public extension CropResult {
  static func mock() -> Self {
    let image = ADResourcesAsset.SampleDrawing.step1Example2.image
    return Self(
      image: image,
      boundingBox: .init(x: 1, y: 1, width: 100, height: 100)
    )
  }
}
