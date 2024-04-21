//
//  FindCharacterJointsScopeAction.swift
//  FindCharacterJointsFeatures
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ModifyJointsFeatures

public extension FindCharacterJointsFeature {
  @CasePathable
  enum ScopeActions: Equatable {
    case modifyJoints(ModifyJointsFeature.Action)
  }
  
  func ScopeReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(.modifyJoints(let modifyJointsActions)):
        switch modifyJointsActions {
        case .delegate(.cancel):
          return .send(.inner(.popModifyJointsView))
          
        case .delegate(.modifyJointsResult(let joints)):
          return .send(.async(.findCharacterJoints(joints)))
          
        default:
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
