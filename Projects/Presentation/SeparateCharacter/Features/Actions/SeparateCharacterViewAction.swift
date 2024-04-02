//
//  SeparateCharacterViewAction.swift
//  SeparateCharacterFeatures
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ADAsyncAlgorithms

public extension SeparateCharacterFeature {
  enum ViewActions: Equatable {
    case task
    case check(CheckActions)
    case pushMaskImageView
  }
  
  enum CheckActions: Equatable {
    case list1(Bool)
    case list2(Bool)
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .task:
          return .run { send in
            let isShowStepBar = await step.isShowStepBar.values()
            let completeStep = await step.completeStep.values()
            
            for await (isShow, complete) in combineLatest(isShowStepBar, completeStep) {
              await send(.update(.getIsShowStepBar(isShow)))
              await send(.update(.getCompleteStep(complete)))
            }
          }
          
        case .check(let checkList):
          switch checkList {
          case .list1(let checkState):
            state.check.list1 = checkState
          case .list2(let checkState):
            state.check.list2 = checkState
          }
          activeMaskImageButton(state: &state)
          return .none
          
        case .pushMaskImageView:
          if state.maskImage == nil {
            return .send(.inner(.noMaskImageErrorAlert))
          }
          state.maskImageView.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
  
  func activeMaskImageButton(state: inout State) {
    if state.check.list1 && state.check.list2 {
      state.maskImageButton = true
    } else {
      state.maskImageButton = false
    }
  }
}
