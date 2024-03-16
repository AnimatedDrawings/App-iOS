//
//  UploadDrawingDelegateAction.swift
//  UploadDrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UploadDrawingInterfaces

public extension UploadDrawingFeature {
  enum DelegateActions: Equatable {
    case moveToFindingTheCharacter(UploadDrawingResult)
  }
  
  func DelegateReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delegate(let delegateActions):
        switch delegateActions {
        default:
          return .none
        }
      default:
        return .none
      }
    }
  }
}
