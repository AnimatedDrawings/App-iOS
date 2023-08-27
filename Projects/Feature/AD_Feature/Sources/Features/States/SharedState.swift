//
//  SharedState.swift
//  AD_Feature
//
//  Created by minii on 2023/06/15.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct SharedState: Equatable {
  public init() {}
  
  public var isShowStepStatusBar = true
  public var currentStep: Step = .UploadADrawing
  private var _completeStep: Step = .UploadADrawing
  public var completeStep: Step {
    get {
      return self._completeStep
    }
    set {
      self._completeStep = newValue
      switch newValue {
      case .UploadADrawing:
        self.croppedImage = nil
        self.maskedImage = nil
        self.jointsDTO = nil
      case .FindingTheCharacter:
        self.maskedImage = nil
        self.jointsDTO = nil
      case .SeparatingCharacter:
        self.jointsDTO = nil
      case .FindingCharacterJoints:
        return
      }
    }
  }
  
  public var ad_id: String? = nil
  
  public var originalImage: UIImage? = nil
  public var boundingBoxDTO: BoundingBoxDTO? = nil
  
  public var initMaskImage: UIImage? = nil
  public var croppedImage: UIImage? = nil
  
  public var maskedImage: UIImage? = nil
  public var jointsDTO: JointsDTO? = nil
  
  public var isShowAddAnimationView = false
}
