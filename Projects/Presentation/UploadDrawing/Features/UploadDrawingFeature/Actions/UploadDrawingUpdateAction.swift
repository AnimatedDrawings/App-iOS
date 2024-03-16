//
//  UploadDrawingUpdateAction.swift
//  UploadDrawingFeatures
//
//  Created by chminii on 3/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels

public extension UploadDrawingFeature {
  @CasePathable
  enum UpdateActions: Equatable {
    case getIsShowStepBar(Bool)
    case getCompleteStep(MakeADStep)
    
    case setIsShowStepBar(Bool)
  }
  
  func UpdateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .update(let updateActions):
        switch updateActions {
        case .getIsShowStepBar(let isShow):
          if state.step.isShowStepBar != isShow {
            state.step.isShowStepBar = isShow
          }
          return .none
        case .getCompleteStep(let completeStep):
          if state.step.completeStep != completeStep {
            state.step.completeStep = completeStep
          }
          return .none
          
        case .setIsShowStepBar(let isShow):
          return .run { send in
            await step.isShowStepBar.set(isShow)
          }
        }
        
      default:
        return .none
      }
    }
  }
}
