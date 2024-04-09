//
//  ModifyJointsViewAction.swift
//  ModifyJointsFeatures
//
//  Created by chminii on 4/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension ModifyJointsFeature {
  enum ViewActions: Equatable {
    case save
    case cancel
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .save:
          return .send(.delegate(.modifyJointsResult))
        case .cancel:
          return .send(.delegate(.cancel))
        }
        
      default:
        return .none
      }
    }
  }
}
