//
//  CropImageState.swift
//  CropImageExample
//
//  Created by chminii on 3/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UIKit
import ADResources
import DomainModels

public extension CropImageFeature {
  @ObservableState
  struct State: Equatable {
    public var originalImage: UIImage
    public var boundingBox: BoundingBox
    public var viewBoundingBox: CGRect
    public var imageScale: CGFloat
    public var resetTrigger: Bool
    
    public init(
      originalImage: UIImage,
      boundingBox: BoundingBox,
      viewBoundingBox: CGRect = .init(),
      imageScale: CGFloat = 1,
      resetTrigger: Bool = true
    ) {
      self.originalImage = originalImage
      self.boundingBox = boundingBox
      self.viewBoundingBox = viewBoundingBox
      self.imageScale = imageScale
      self.resetTrigger = resetTrigger
    }
  }
}

public extension CropImageFeature.State {
  static func mock() -> Self {
    let originalImage = ADResourcesAsset.TestImages.originalImage.image
    let boundingBox = BoundingBox.mock()
    
    return Self(
      originalImage: originalImage,
      boundingBox: boundingBox
    )
  }
}
