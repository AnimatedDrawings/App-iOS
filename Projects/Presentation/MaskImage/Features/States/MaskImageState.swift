//
//  MaskImageState.swift
//  MaskImageFeatures
//
//  Created by chminii on 3/28/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import UIKit
import ADComposableArchitecture

public extension MaskImageFeature {
  @ObservableState
  struct State: Equatable {
    public let croppedImage: UIImage
    public let maskedImage: UIImage
    public var drawingToolState: DrawingToolState
    
    public init(croppedImage: UIImage, maskedImage: UIImage, drawingToolState: DrawingToolState = .erase) {
      self.croppedImage = croppedImage
      self.maskedImage = maskedImage
      self.drawingToolState = drawingToolState
    }
    
//    public var drawingState: DrawingTool
//    @BindingState public var circleRadius: CGFloat
//
//    public var undoTrigger = false
//    public var resetTrigger = false
//    public var saveTrigger = false
//
//    public init(
//      drawingState: DrawingTool = .erase,
//      circleRadius: CGFloat = 0
//    ) {
//      self.drawingState = drawingState
//      self.circleRadius = circleRadius
//    }
  }
}

public enum DrawingToolState: Equatable {
  case draw
  case erase
}

public enum MaskToolState: Equatable {
  case undo
  case reset
}
