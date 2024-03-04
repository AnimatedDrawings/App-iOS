//
//  CropImageState.swift
//  CropImageExample
//
//  Created by chminii on 3/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

public extension CropImageFeature {
  @ObservableState
  struct State: Equatable {
    public var originalImage: UIImage
    public var boundingBox: CGRect
    public var viewBoundingBox: CGRect = .init()
    public var imageScale: CGFloat = 1
    public var resetTrigger: Bool = true
    
    public init(
      originalImage: UIImage,
      boundingBox: CGRect
    ) {
      self.originalImage = originalImage
      self.boundingBox = boundingBox
    }
  }
}
