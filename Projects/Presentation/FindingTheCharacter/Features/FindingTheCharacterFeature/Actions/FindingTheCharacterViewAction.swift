//
//  FindingTheCharacterViewAction.swift
//  FindingTheCharacter
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib

public extension FindingTheCharacterFeature {
  enum ViewActions: Equatable {
    case checkList(Bool)
    case initState
  }
  
  func ViewReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .checkList(let checkState):
          state.checkList = checkState
          return .none
        case .initState:
          state = FindingTheCharacterFeature.State()
          return .none
        }
      default:
        return .none
      }
    }
  }
}

public extension FindingTheCharacterFeature {
  enum InnerActions: Equatable {
    case alert
    case setLoadingView(Bool)
    case presentCropImageView
  }
  
  func InnerReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .inner(let innerActions):
        switch innerActions {
        case .alert:
          state.alert.networkError.toggle()
          return .none
        case .setLoadingView(let isShow):
          state.loadingView = isShow
          return .none
        case .presentCropImageView:
          state.cropImageView.toggle()
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
