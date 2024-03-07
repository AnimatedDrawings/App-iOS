//
//  UploadADrawingUpdateAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 3/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel

public extension UploadADrawingFeature {
  @CasePathable
  enum UpdateActions: Equatable {
    case task
    case getIsShowStepBar(Bool)
    case setIsShowStepBar(Bool)
    case getCompleteStep(MakeADStep)
  }
  
  func UpdateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .update(let updateActions):
        switch updateActions {
        case .task:
          return .run { send in
            for await isShow in await stepBar.isShowStepBar.values() {
              await send(.update(.getIsShowStepBar(isShow)))
            }
            
            for await step in await stepBar.completeStep.values() {
              await send(.update(.getCompleteStep(step)))
            }
          }
          
        case .getIsShowStepBar(let isShow):
          state.step.isShowStepBar = isShow
          return .none
        case .setIsShowStepBar(let isShow):
          return .run { send in
            await stepBar.isShowStepBar.set(isShow)
          }
        case .getCompleteStep(let step):
          state.step.completeStep = step
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
