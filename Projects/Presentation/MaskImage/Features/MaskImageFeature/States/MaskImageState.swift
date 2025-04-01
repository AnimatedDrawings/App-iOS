//
//  MaskImageState.swift
//  MaskImageFeatures
//
//  Created by chminii on 3/28/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ADResources
import Foundation
import UIKit

extension MaskImageFeature {
  @ObservableState
  public struct State: Equatable {
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
  public struct TriggerState: Equatable {
    public var drawingTool: DrawingTool
    public var maskCache: MaskCache
    public var save: Bool

    public init(
      drawingTool: DrawingTool = .erase,
      maskCache: MaskCache = .init(),
      save: Bool = false
    ) {
      self.drawingTool = drawingTool
      self.maskCache = maskCache
      self.save = save
    }
  }
}

extension MaskImageFeature.State {
  public static func mock() -> Self {
    let croppedImage: UIImage = ADResourcesAsset.GarlicTestImages.croppedImage.image
    let maskedImage: UIImage = ADResourcesAsset.GarlicTestImages.maskedImage.image
    return .init(croppedImage: croppedImage, maskedImage: maskedImage)
  }
}

public enum DrawingTool: Equatable {
  case draw
  case erase
}

public struct MaskCache: Equatable {
  public var undo: Bool
  public var reset: Bool

  public init(
    undo: Bool = false,
    reset: Bool = false
  ) {
    self.undo = undo
    self.reset = reset
  }
}
