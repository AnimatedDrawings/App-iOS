//
//  RootViewAction.swift
//  RootFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension RootFeature {
  enum ViewActions: Equatable {
    case task
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .task:
          return .run { send in
            for await currentView in await adview.adViewState.values() {
              await send(.update(.getADViewState(currentView)))
            }
          }
        }
        
      default:
        return .none
      }
    }
  }
}
