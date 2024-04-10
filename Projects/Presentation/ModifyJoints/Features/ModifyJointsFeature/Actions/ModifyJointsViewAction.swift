//
//  ModifyJointsViewAction.swift
//  ModifyJointsFeatures
//
//  Created by chminii on 4/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels

public extension ModifyJointsFeature {
  enum ViewActions: Equatable {
    case save([String : Skeleton])
    case cancel
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .save(let skeletons):
          var newJoints = state.originJoints
          newJoints.skeletons = skeletons
          return .send(.delegate(.modifyJointsResult(newJoints)))
        case .cancel:
          return .send(.delegate(.cancel))
        }
        
      default:
        return .none
      }
    }
  }
}
