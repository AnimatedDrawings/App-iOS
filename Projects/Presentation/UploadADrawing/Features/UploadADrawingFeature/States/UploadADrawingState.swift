//
//  UploadADrawingState.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel

public extension UploadADrawingFeature {
  struct State: Equatable {
    public var stepBar: StepBarState
    
    public var checkState: CheckState
    public var isActiveUploadButton: Bool
    
    public var isShowLoadingView: Bool
    @BindingState public var isShowNetworkErrorAlert: Bool
    @BindingState public var isShowFindCharacterErrorAlert: Bool
    @BindingState public var isShowImageSizeErrorAlert: Bool
    
    public init(
      stepBar: StepBarState = .init(),
      checkState: CheckState = .init(),
      isEnableUploadButton: Bool = false,
      isShowLoadingView: Bool = false,
      isShowNetworkErrorAlert: Bool = false,
      isShowFindCharacterErrorAlert: Bool = false,
      isShowImageSizeErrorAlert: Bool = false
    ) {
      self.stepBar = stepBar
      self.checkState = checkState
      self.isActiveUploadButton = isEnableUploadButton
      self.isShowLoadingView = isShowLoadingView
      self.isShowNetworkErrorAlert = isShowNetworkErrorAlert
      self.isShowFindCharacterErrorAlert = isShowFindCharacterErrorAlert
      self.isShowImageSizeErrorAlert = isShowImageSizeErrorAlert
    }
  }
  
  struct CheckState: Equatable {
    public var check1: Bool
    public var check2: Bool
    public var check3: Bool
    public var check4: Bool
    
    public init(
      check1: Bool = false,
      check2: Bool = false,
      check3: Bool = false,
      check4: Bool = false
    ) {
      self.check1 = check1
      self.check2 = check2
      self.check3 = check3
      self.check4 = check4
    }
  }
}
