//
//  UploadDrawingViewAction.swift
//  UploadDrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UIKit
import ADAsyncAlgorithms

public extension UploadDrawingFeature {
  @CasePathable
  enum ViewActions: Equatable {
    case task
    case check(CheckActions)
    case uploadDrawing(Data?)
  }
  
  @CasePathable
  enum CheckActions: Equatable {
    case list1(Bool)
    case list2(Bool)
    case list3(Bool)
    case list4(Bool)
  }
  
  func ViewReducer() -> some Reducer<State, Action> {
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
          case .list3(let checkState):
            state.check.list3 = checkState
          case .list4(let checkState):
            state.check.list4 = checkState
          }
          activeUploadButton(state: &state)
          return .none
          
        case .uploadDrawing(let imageData):
          return .send(.async(.uploadDrawing(imageData)))
        }
        
      default:
        return .none
      }
    }
  }
  
  func activeUploadButton(state: inout State) {
    if state.check.list1 && state.check.list2
        && state.check.list3 && state.check.list4
    {
      state.uploadButton = true
    } else {
      state.uploadButton = false
    }
  }
}

