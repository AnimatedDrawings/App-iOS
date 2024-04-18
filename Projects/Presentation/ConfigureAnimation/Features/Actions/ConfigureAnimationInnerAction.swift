//
//  ConfigureAnimationInnerAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

public extension ConfigureAnimationFeature {
  enum InnerActions: Equatable {
    case alertNoAnimationFile
    case alertSaveGifResult(Bool)
    case sheetShareFile
  }
  
  func InnerReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .inner(let innerActions):
        switch innerActions {
        case .alertNoAnimationFile:
          state.share.alertNoAnimation.toggle()
          return .none
          
        case .alertSaveGifResult(let isSuccess):
          state.share.saveResult.isSuccess = isSuccess
          state.share.saveResult.alert.toggle()
          return .none
          
        case .sheetShareFile:
          state.share.sheetShareFile.toggle()
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
