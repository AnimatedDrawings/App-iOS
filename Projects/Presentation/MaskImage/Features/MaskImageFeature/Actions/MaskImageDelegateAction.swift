//
//  MaskImageDelegateAction.swift
//  MaskImageFeatures
//
//  Created by chminii on 3/28/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import MaskImageInterfaces

public extension MaskImageFeature {
  enum DelegateActions: Equatable {
    case maskImageResult(MaskImageResult)
    case cancel
  }
  
  func DelegateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        case .maskImageResult:
          return .none
        case .cancel:
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
