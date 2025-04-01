//
//  SeparateCharacterScopeAction.swift
//  SeparateCharacterFeatures
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import MaskImageFeatures

extension SeparateCharacterFeature {
  @CasePathable
  public enum ScopeActions: Equatable {
    case maskImage(MaskImageFeature.Action)
  }

  public func ScopeReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(let scopeActions):
        switch scopeActions {
        case .maskImage(.delegate(.maskImageResult(let maskImageResult))):
          return .send(.async(.separateCharacter(maskImageResult)))

        case .maskImage(.delegate(.cancel)):
          return .send(.inner(.popMaskImageView))

        default:
          return .none
        }

      default:
        return .none
      }
    }
  }
}
