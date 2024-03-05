//
//  CropResult.swift
//  ImageCompressor
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit

public struct CropResult: Equatable {
  public let image: UIImage
  public let boundingBox: CGRect
  
  public init(image: UIImage, boundingBox: CGRect) {
    self.image = image
    self.boundingBox = boundingBox
  }
}
