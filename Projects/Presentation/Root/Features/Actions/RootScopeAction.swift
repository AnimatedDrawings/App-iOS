//
//  RootScopeAction.swift
//  RootFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ConfigureAnimationFeatures
import MakeADFeatures

extension RootFeature {
  @CasePathable
  public enum ScopeActions: Equatable {
    case makeAD(MakeADFeature.Action)
    case configureAnimation(ConfigureAnimationFeature.Action)
  }

  public func ScopeReducer() -> some ReducerOf<Self> {
    CombineReducers {
      ConfigureAnimationReducer()
    }
  }

  public func ConfigureAnimationReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(.configureAnimation(.delegate(let configureAnimationDelegateActions))):
        switch configureAnimationDelegateActions {
        case .resetMakeAD:
          state.makeAD = .init()
          state.configureAnimation = .init()

          return .run { send in
            await step.completeStep.set(.None)
            await step.currentStep.set(.UploadDrawing)
            await step.isShowStepBar.set(true)
            await adview.adViewState.set(.MakeAD)
          }

          return .none
        }

      default:
        return .none
      }
    }
  }
}
