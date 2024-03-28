//
//  FindTheCharacterViewAction.swift
//  FindTheCharacter
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import CropImageFeatures
import ADAsyncAlgorithms

public extension FindTheCharacterFeature {
  enum ViewActions: Equatable {
    case task
    case checkList(Bool)
    case toggleCropImageView
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
          
        case .checkList(let checkState):
          state.checkList = checkState
          return .none
        case .toggleCropImageView:
          if state.cropImage == nil {
            return .send(.inner(.noCropImageErrorAlert))
          }
          state.cropImageView.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
}
