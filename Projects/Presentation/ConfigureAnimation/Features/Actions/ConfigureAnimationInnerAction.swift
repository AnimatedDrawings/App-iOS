//
//  ConfigureAnimationInnerAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension ConfigureAnimationFeature {
  enum InnerActions: Equatable {
    case resetMakeAD
  }
  
  func InnerReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .inner(let innerActions):
        switch innerActions {
        case .resetMakeAD:
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
