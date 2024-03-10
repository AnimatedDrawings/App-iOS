//
//  FindingTheCharacterScopeAction.swift
//  FindingTheCharacterFeatures
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import CropImageFeatures

public extension FindingTheCharacterFeature {
  @CasePathable
  enum ScopeActions: Equatable {
    case cropImage(CropImageFeature.Action)
  }
  
  func ScopeReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .scope(let scopeActions):
        switch scopeActions {
        case .cropImage(.delegate(.cropResult(let cropResult))):
          return .send(.async(.findTheCharacter(cropResult)))
        case .cropImage(.delegate(.cancel)):
          return .send(.inner(.toggleCropImageView))
        default:
          return .none
        }
      default:
        return .none
      }
    }
  }
}
