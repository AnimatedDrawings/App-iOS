//
//  UploadADrawingViewAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

public extension UploadADrawingFeature {
  enum ViewAction: Equatable {
    case check(Check)
    case uploadDrawing(Data?)
    case initState
  }
  
  enum Check: Equatable {
    case list1
    case list2
    case list3
    case list4
  }
  
  func ViewReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .view(let viewAction):
        switch viewAction {
          
        case .check(let checkList):
          switch checkList {
          case .list1:
            state.checkState.check1.toggle()
          case .list2:
            state.checkState.check2.toggle()
          case .list3:
            state.checkState.check3.toggle()
          case .list4:
            state.checkState.check4.toggle()
          }
          activeUploadButton(state: &state)
          return .none
          
        case .uploadDrawing(let imageData):
          return .send(.async(.uploadDrawing(imageData)))
          
        case .initState:
          state = State()
          return .none
        }
        
      default:
        return .none
      }
    }
  }
  
  func activeUploadButton(state: inout State) {
    if state.checkState.check1 && state.checkState.check2
        && state.checkState.check3 && state.checkState.check4
    {
      state.isActiveUploadButton = true
    } else {
      state.isActiveUploadButton = false
    }
  }
}
