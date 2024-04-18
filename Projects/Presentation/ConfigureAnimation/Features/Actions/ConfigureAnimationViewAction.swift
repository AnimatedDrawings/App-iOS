//
//  ConfigureAnimationViewAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension ConfigureAnimationFeature {
  enum ViewActions: Equatable {
    case tabBar(TabBarActions)
    case trashConfirm
  }
  
  enum TabBarActions: Equatable {
    case fix
    case trash(TrashActions)
    case share
    case animation
  }
  
  enum TrashActions: Equatable {
    case showAlert
    case confirmTrash
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .tabBar(let tabBarActions):
          switch tabBarActions {
          case .fix:
            return .run { send in
              await adViewState.adViewState.set(.MakeAD)
            }
            
          case .trash(let trashActions):
            switch trashActions {
            case .showAlert:
              state.alert.trash.toggle()
              return .none
            case .confirmTrash:
              return .send(.delegate(.resetMakeAD))
            }
            
          case .share:
            return .none
            
          case .animation:
            return .none
          }
          
        default:
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
