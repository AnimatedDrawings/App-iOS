//
//  FindCharacterJointsViewAction.swift
//  FindCharacterJointsFeatures
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ADAsyncAlgorithms

public extension FindCharacterJointsFeature {
  enum ViewActions: Equatable {
    case task
    case pushModifyJointsView
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
          
        case .pushModifyJointsView:
          state.modifyJointsView.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
}
