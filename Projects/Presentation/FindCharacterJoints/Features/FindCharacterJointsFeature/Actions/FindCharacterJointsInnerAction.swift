//
//  FindCharacterJointsInnerAction.swift
//  FindCharacterJointsFeatures
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension FindCharacterJointsFeature {
  enum InnerActions: Equatable {
    case setLoadingView(Bool)
    case popModifyJointsView
    case networkErrorAlert
  }
  
  func InnerReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .inner(let innerActions):
        switch innerActions {
        case .setLoadingView(let isShow):
          state.loadingView = isShow
          return .none
          
        case .popModifyJointsView:
          state.modifyJointsView.toggle()
          return .none
          
        case .networkErrorAlert:
          state.alert.networkError.toggle()
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
