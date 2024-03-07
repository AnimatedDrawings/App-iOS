//
//  MakeADUpdateAction.swift
//  MakeADFeatures
//
//  Created by chminii on 3/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel
import AsyncAlgorithms

public extension MakeADFeature {
  @CasePathable
  enum UpdateActions: Equatable {
    case task
    
    case getIsShowStepBar(Bool)
    case getCurrentStep(MakeADStep)
    case getCompleteStep(MakeADStep)
    
    case setCurrentStep(MakeADStep)
  }
  
  func UpdateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .update(let updateActions):
        switch updateActions {
        case .task:
          return .run { send in
            let isShowStepBar = await stepBar.isShowStepBar.values()
            let currentStep = await stepBar.currentStep.values()
            let completeStep = await stepBar.completeStep.values()
            
            for await (isShow, current, complete) in combineLatest(isShowStepBar, currentStep, completeStep) {
              await send(.update(.getIsShowStepBar(isShow)))
              await send(.update(.getCurrentStep(current)))
              await send(.update(.getCompleteStep(complete)))
            }
          }
          
        case .getIsShowStepBar(let isShow):
          if state.step.isShowStepBar != isShow {
            state.step.isShowStepBar = isShow
          }
          return .none
          
        case .getCurrentStep(let step):
          if state.step.currentStep != step {
            state.step.currentStep = step
          }
          return .none
          
        case .getCompleteStep(let step):
          if state.step.completeStep != step {
            state.step.completeStep = step
          }
          return .none
          
        case .setCurrentStep(let step):
          return .run { send in
            await stepBar.currentStep.set(step)
          }
        }
      default:
        return .none
      }
    }
  }
}
