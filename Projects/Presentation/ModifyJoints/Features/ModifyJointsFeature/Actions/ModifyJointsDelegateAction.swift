//
//  ModifyJointsDelegateAction.swift
//  ModifyJointsFeatures
//
//  Created by chminii on 4/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels

public extension ModifyJointsFeature {
  enum DelegateActions: Equatable {
    case modifyJointsResult(Joints)
    case cancel
  }
  
  func DelegateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        case .modifyJointsResult:
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
