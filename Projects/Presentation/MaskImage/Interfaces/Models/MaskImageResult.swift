//
//  MaskImageResult.swift
//  MaskImageInterfaces
//
//  Created by chminii on 3/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import ADResources

public struct MaskImageResult: Equatable {
  public let image: UIImage
  
  public init(image: UIImage) {
    self.image = image
  }
}

public extension MaskImageResult {
  static func mock() -> Self {
    let image: UIImage = ADResourcesAsset.TestImages.maskedImage.image
    return Self(image: image)
  }
}
