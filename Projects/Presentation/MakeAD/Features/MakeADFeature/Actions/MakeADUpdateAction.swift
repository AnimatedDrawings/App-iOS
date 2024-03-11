//
//  MakeADUpdateAction.swift
//  MakeADFeatures
//
//  Created by chminii on 3/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModel

public extension MakeADFeature {
  @CasePathable
  enum UpdateActions: Equatable {
    case getIsShowstep(Bool)
    case getCurrentStep(MakeADStep)
    case getCompleteStep(MakeADStep)
    
    case setCurrentStep(MakeADStep)
  }
  
  func UpdateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .update(let updateActions):
        switch updateActions {
        case .getIsShowstep(let isShow):
          if state.step.isShowStepBar != isShow {
            state.step.isShowStepBar = isShow
          }
          return .none
        case .getCurrentStep(let currentStep):
          if state.step.currentStep != currentStep {
            state.step.currentStep = currentStep
          }
          return .none
        case .getCompleteStep(let completeStep):
          if state.step.completeStep != completeStep {
            state.step.completeStep = completeStep
          }
          return .none
          
        case .setCurrentStep(let currentStep):
          return .run { send in
            await step.currentStep.set(currentStep)
          }
        }
      default:
        return .none
      }
    }
  }
}
