//
//  CropImageDelegateAction.swift
//  CropImageFeatures
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import CropImageInterfaces

public extension CropImageFeature {
  enum DelegateActions: Equatable {
    case cropImageResult(CropImageResult)
    case cancel
  }
  
  func DelegateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        case .cropImageResult:
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
