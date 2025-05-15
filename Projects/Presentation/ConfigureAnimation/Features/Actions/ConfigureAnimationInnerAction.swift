//
//  ConfigureAnimationInnerAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

extension ConfigureAnimationFeature {
  public enum InnerActions: Equatable {
    case alertNoAnimationFile
    case alertSaveGifResult(Bool)
    case alertNetworkError
    case alertFullJob
    case sheetShareFile
    case setLoadingView(Bool)
    case toggleAnimationListView
    case updateLoadingDescription(String)

    case setViewNeworkFail
    case setFullJob
  }

  public func InnerReducer() -> some ReducerOf<Self> {
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

        case .alertNetworkError:
          state.configure.networkError.toggle()
          return .none

        case .alertFullJob:
          state.configure.fullJob.toggle()
          return .none

        case .sheetShareFile:
          state.share.sheetShareFile.toggle()
          return .none

        case .setLoadingView(let isShow):
          state.configure.loadingView = isShow
          return .none

        case .toggleAnimationListView:
          state.configure.animationListView.toggle()
          return .none

        case .updateLoadingDescription(let description):
          state.configure.loadingDescription = description
          return .none

        case .setViewNeworkFail:
          state.configure.selectedAnimation = nil
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.alertNetworkError))
          }

        case .setFullJob:
          state.configure.selectedAnimation = nil
          return .run { send in
            await send(.inner(.alertFullJob))
            await send(.inner(.setLoadingView(false)))
          }
        }

      default:
        return .none
      }
    }
  }
}
