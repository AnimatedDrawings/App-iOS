//
//  SeparateCharacterInnerAction.swift
//  SeparateCharacterFeatures
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension SeparateCharacterFeature {
  @CasePathable
  enum InnerActions: Equatable {
    case setLoadingView(Bool)
    
    case noMaskImageErrorAlert
    case networkErrorAlert
    case popMaskImageView
  }
  
  func InnerReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .inner(let innerActions):
        switch innerActions {
        case .setLoadingView(let isShow):
          state.loadingView = isShow
          return .none
          
        case .noMaskImageErrorAlert:
          state.alert.noMaskImage.toggle()
          return .none
          
        case .networkErrorAlert:
          state.alert.networkError.toggle()
          return .none
          
        case .popMaskImageView:
          state.maskImageView.toggle()
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
