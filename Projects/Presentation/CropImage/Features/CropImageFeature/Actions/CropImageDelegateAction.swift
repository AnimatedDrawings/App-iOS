//
//  CropImageDelegateAction.swift
//  CropImageFeatures
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModel

public extension CropImageFeature {
  enum DelegateActions: Equatable {
    case cropResult(CropResult)
    case cancel
  }
  
  func DelegateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        case .cropResult:
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
