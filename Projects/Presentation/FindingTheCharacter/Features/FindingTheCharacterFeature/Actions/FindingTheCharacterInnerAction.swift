//
//  FindingTheCharacterInnerAction.swift
//  FindingTheCharacterFeatures
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib

public extension FindingTheCharacterFeature {
  enum InnerActions: Equatable {
    case setLoadingView(Bool)
    case presentCropImageView
    
    case networkErrorAlert
    case noCropImageErrorAlert
  }
  
  func InnerReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .inner(let innerActions):
        switch innerActions {
        case .setLoadingView(let isShow):
          state.loadingView = isShow
          return .none
        case .presentCropImageView:
          state.cropImageView.toggle()
          return .none
          
        case .networkErrorAlert:
          state.alert.networkError.toggle()
          return .none
        case .noCropImageErrorAlert:
          state.alert.noCropImage.toggle()
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}

