//
//  UploadADrawingInnerAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModel

public extension UploadADrawingFeature {
  enum InnerActions: Equatable {
    case setLoadingView(Bool)
    case showNetworkErrorAlert
    case showFindCharacterErrorAlert
    case showImageSizeErrorAlert
  }
  
  func InnerReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .inner(let innerActions):
        switch innerActions {
        case .setLoadingView(let isShow):
          state.loadingView = isShow
          return .none
          
        case .showNetworkErrorAlert:
          state.alert.networkError.toggle()
          return .none
          
        case .showFindCharacterErrorAlert:
          state.alert.findCharacterError.toggle()
          return .none
          
        case .showImageSizeErrorAlert:
          state.alert.imageSizeError.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
}
