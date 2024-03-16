//
//  ImageCropper.swift
//  ImageCompressor
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import DomainModels
import UIKit
import ADComposableArchitecture

public struct ImageCropper {
  public var crop: @Sendable (CropRequest) throws -> CropResult
}

extension ImageCropper: DependencyKey {
  public static let liveValue = Self(
    crop: { request in
      let reciprocal: CGFloat = 1 / request.imageScale
      
      let cropCGSize = CGSize(
        width: request.viewBoundingBox.width * reciprocal,
        height: request.viewBoundingBox.height * reciprocal
      )
      
      let cropCGPoint = CGPoint(
        x: -request.viewBoundingBox.minX * reciprocal,
        y: -request.viewBoundingBox.minY * reciprocal
      )
      
      UIGraphicsBeginImageContext(cropCGSize)
      request.originalImage.draw(at: cropCGPoint)
      guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
        throw NSError()
      }
      
      let boundingBox = CGRect(
        origin: CGPoint(x: -cropCGPoint.x, y: -cropCGPoint.y),
        size: cropCGSize
      )
      
      let cropResult = CropResult(image: image, boundingBox: boundingBox)
      return cropResult
    }
  )
  
  public static let testValue = Self(
    crop: { request in
      CropResult(image: request.originalImage, boundingBox: request.viewBoundingBox)
    }
  )
}
