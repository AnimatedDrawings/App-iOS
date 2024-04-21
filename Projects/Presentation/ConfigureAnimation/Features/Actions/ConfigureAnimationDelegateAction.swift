//
//  ConfigureAnimationDelegateAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension ConfigureAnimationFeature {
  enum DelegateActions: Equatable {
    case resetMakeAD
  }
  
  func DelegateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        case .resetMakeAD:
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
