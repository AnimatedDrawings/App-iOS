//
//  UploadADrawingState.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModel
import UIKit

public extension UploadADrawingFeature {
  @ObservableState
  struct State: Equatable {
    public var check: Check
    public var uploadButton: Bool
    public var loadingView: Bool
    public var alert: Alert
    public var step: StepState
    
    var originalImage: UIImage
    
    public init(
      check: Check = .init(),
      uploadButton: Bool = .init(),
      loadingView: Bool = .init(),
      alert: Alert = .init(),
      step: StepState = .init()
    ) {
      self.check = check
      self.uploadButton = uploadButton
      self.loadingView = loadingView
      self.alert = alert
      self.step = step
      self.originalImage = UIImage()
    }
  }
  
  @ObservableState
  struct Alert: Equatable {
    public var networkError: Bool
    public var findCharacterError: Bool
    public var imageSizeError: Bool
    
    public init(
      networkError: Bool = false,
      findCharacterError: Bool = false,
      imageSizeError: Bool = false
    ) {
      self.networkError = networkError
      self.findCharacterError = findCharacterError
      self.imageSizeError = imageSizeError
    }
  }
  
  @ObservableState
  struct Check: Equatable {
    public var list1: Bool
    public var list2: Bool
    public var list3: Bool
    public var list4: Bool
    
    public init(
      list1: Bool = false,
      list2: Bool = false,
      list3: Bool = false,
      list4: Bool = false
    ) {
      self.list1 = list1
      self.list2 = list2
      self.list3 = list3
      self.list4 = list4
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
