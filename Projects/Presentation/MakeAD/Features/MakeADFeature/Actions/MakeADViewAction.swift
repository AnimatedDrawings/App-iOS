//
//  MakeADViewAction.swift
//  MakeADFeatures
//
//  Created by chminii on 3/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import AsyncAlgorithms

public extension MakeADFeature {
  enum ViewActions: Equatable {
    case task
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .task:
          return .run { send in
            let isShowStepBar = await step.isShowStepBar.values()
            let currentStep = await step.currentStep.values()
            let completeStep = await step.completeStep.values()
            
            for await (isShow, current, complete) in combineLatest(isShowStepBar, currentStep, completeStep) {
              await send(.update(.getIsShowstep(isShow)))
              await send(.update(.getCurrentStep(current)))
              await send(.update(.getCompleteStep(complete)))
            }
          }
        }
        
      default:
        return .none
      }
    }
  }
}
