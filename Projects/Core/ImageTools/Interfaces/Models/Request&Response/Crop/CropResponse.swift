//
//  CropResponse.swift
//  ImageToolsInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADUIKit
import ADResources
import UIKit

public struct CropResponse: Equatable {
  public let image: UIImage
  public let boundingBox: CGRect

  public init(image: UIImage, boundingBox: CGRect) {
    self.image = image
    self.boundingBox = boundingBox
  }
}

extension CropResponse {
  public static func mock(_ devResource: DevResources) -> Self {
    let image: UIImage = devResource.croppedImage.image
    let boundingBox: CGRect = devResource.boundingBox
    
    return .init(
      image: image,
      boundingBox: boundingBox
    )
  }
}
