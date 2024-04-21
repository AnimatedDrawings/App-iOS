//
//  RootUpdateAction.swift
//  RootFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels

public extension RootFeature {
  enum UpdateActions: Equatable {
    case getADViewState(ADViewState)
  }
  
  func UpdateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .update(let updateActions):
        switch updateActions {
        case .getADViewState(let adViewState):
          if state.adViewState != adViewState {
            state.adViewState = adViewState
          }
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
