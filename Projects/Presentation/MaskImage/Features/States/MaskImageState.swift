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
    public var toolCircleSize: CGFloat
    public var triggerState: TriggerState
    
    public init(
      croppedImage: UIImage,
      maskedImage: UIImage,
      toolCircleSize: CGFloat = 15,
      triggerState: TriggerState = .init()
    ) {
      self.croppedImage = croppedImage
      self.maskedImage = maskedImage
      self.toolCircleSize = toolCircleSize
      self.triggerState = triggerState
    }
  }
  
  @ObservableState
  struct TriggerState: Equatable {
    public var drawingTool: DrawingTool
    public var maskTool: MaskTool
    public var save: Bool
    
    public init(
      drawingTool: DrawingTool = .erase,
      maskTool: MaskTool = .undo,
      save: Bool = false
    ) {
      self.drawingTool = drawingTool
      self.maskTool = maskTool
      self.save = save
    }
  }
}


public enum DrawingTool: Equatable {
  case draw
  case erase
}

public enum MaskTool: Equatable {
  case undo
  case reset
}
