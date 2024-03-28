//
//  MaskImageViewAction.swift
//  MaskImageFeatures
//
//  Created by chminii on 3/28/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import MaskImageInterfaces

public extension MaskImageFeature {
  enum ViewActions: Equatable {
    case save
    case cancel
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .save:
          let maskImageResult = MaskImageResult.mock()
          return .send(.delegate(.maskImageResult(maskImageResult)))
        case .cancel:
          return .send(.delegate(.cancel))
        }
        
      default:
        return .none
      }
    }
  }
}
