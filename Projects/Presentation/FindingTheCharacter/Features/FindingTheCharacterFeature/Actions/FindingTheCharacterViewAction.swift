//
//  FindingTheCharacterViewAction.swift
//  FindingTheCharacter
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import CropImageFeatures

public extension FindingTheCharacterFeature {
  enum ViewActions: Equatable {
    case checkList(Bool)
    case toggleCropImageView
    case onDismissCropImageView
    case initState
  }
  
  func ViewReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .checkList(let checkState):
          state.checkList = checkState
          return .none
        case .toggleCropImageView:
          if state.cropImage != nil {
            state.cropImageView.toggle()
          } else {
            return .send(.inner(.noCropImageErrorAlert))
          }
          return .none
        case .onDismissCropImageView:
          return .none
        case .initState:
          state = FindingTheCharacterFeature.State()
          return .none
        }
      default:
        return .none
      }
    }
  }
}
