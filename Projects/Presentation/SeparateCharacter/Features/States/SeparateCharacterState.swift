//
//  SeparateCharacterState.swift
//  SeparateCharacterFeatures
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import MaskImageFeatures
import UIKit

public extension SeparateCharacterFeature {
  @ObservableState
  struct State: Equatable {
    public var check: Check
    public var step: StepState
    public var alert: Alert
    public var maskImageButton: Bool
    public var maskImageView: Bool
    public var loadingView: Bool
    
    public var maskedImage: UIImage?
    public var maskImage: MaskImageFeature.State?
    
    public init(
      check: Check = .init(),
      step: StepState = .init(),
      alert: Alert = .init(),
      maskImageButton: Bool = false,
      maskImageView: Bool = false,
      loadingView: Bool = false,
      
      maskedImage: UIImage? = nil,
      maskImage: MaskImageFeature.State? = nil
    ) {
      self.check = check
      self.step = step
      self.alert = alert
      self.maskImageButton = maskImageButton
      self.maskImageView = maskImageView
      self.loadingView = loadingView
      
      self.maskedImage = maskedImage
      self.maskImage = maskImage
    }
  }
  
  @ObservableState
  struct Alert: Equatable {
    public var noMaskImage: Bool
    public var networkError: Bool
    
    public init(
      noMaskImage: Bool = false,
      networkError: Bool = false
    ) {
      self.noMaskImage = noMaskImage
      self.networkError = networkError
    }
  }
  
  @ObservableState
  struct Check: Equatable {
    public var list1: Bool
    public var list2: Bool
    
    public init(
      list1: Bool = false,
      list2: Bool = false
    ) {
      self.list1 = list1
      self.list2 = list2
    }
  }
  
  @ObservableState
  struct StepState: Equatable {
    public var isShowStepBar: Bool
    public var completeStep: MakeADStep
    
    public init(
      isShowStepBar: Bool = true,
      completeStep: MakeADStep = .None
    ) {
      self.isShowStepBar = isShowStepBar
      self.completeStep = completeStep
    }
  }
}
