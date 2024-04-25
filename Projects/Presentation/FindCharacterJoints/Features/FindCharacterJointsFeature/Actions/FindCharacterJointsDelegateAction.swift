//
//  FindCharacterJointsDelegateAction.swift
//  FindCharacterJointsFeatures
//
//  Created by chminii on 4/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension FindCharacterJointsFeature {
  enum DelegateActions: Equatable {
    case findCharacterJointsResult
  }
  
  func DelegateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        case .findCharacterJointsResult:
          return .none
        }
      default:
        return .none
      }
    }
  }
}
