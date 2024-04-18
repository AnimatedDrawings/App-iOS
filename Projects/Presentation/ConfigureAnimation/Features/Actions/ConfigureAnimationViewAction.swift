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
    case fix
    case trash(TrashActions)
    case share(ShareActions)
    case animation
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    CombineReducers {
      FixReducer()
      TrashReducer()
      ShareReducer()
    }
  }
}


// MARK: - Fix Actions

public extension ConfigureAnimationFeature {
  func FixReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .fix:
          return .run { send in
            await adViewState.adViewState.set(.MakeAD)
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

// MARK: - Trash Actions

public extension ConfigureAnimationFeature {
  enum TrashActions: Equatable {
    case showAlert
    case trashAlertActions(TrashAlertActions)
  }
  
  enum TrashAlertActions: Equatable {
    case confirm
  }
  
  func TrashReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(.trash(let trashActions)):
        switch trashActions {
        case .showAlert:
          state.trash.alert.toggle()
          return .none
        case .trashAlertActions(.confirm):
          return .send(.delegate(.resetMakeAD))
        }
        
      default:
        return .none
      }
    }
  }
}

// MARK: - Trash Actions

public extension ConfigureAnimationFeature {
  enum ShareActions: Equatable {
    case showShareSheet
    case shareSheetActions(ShareSheetActions)
  }
  
  enum ShareSheetActions: Equatable {
    case save
    case share
  }
  
  func ShareReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(.share(let shareActions)):
        switch shareActions {
        case .showShareSheet:
          if state.currentAnimation == nil {
            return .send(.inner(.alertNoAnimationFile))
          }
          state.share.sheetShare.toggle()
          return .none
          
        case .shareSheetActions(let shareSheetActions):
          guard let currentAnimation = state.currentAnimation else {
            return .none
          }
          
          switch shareSheetActions {
          case .save:
            return .send(.async(.saveGifInPhotos(currentAnimation.url)))
          case .share:
            return .send(.inner(.sheetShareFile))
          }
        }
        
      default:
        return .none
      }
    }
  }
}
