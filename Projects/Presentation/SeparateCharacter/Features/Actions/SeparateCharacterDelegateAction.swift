//
//  SeparateCharacterDelegateAction.swift
//  SeparateCharacterFeatures
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import SeparateCharacterInterfaces

public extension SeparateCharacterFeature {
  @CasePathable
  enum DelegateActions: Equatable {
    case moveToFindCharacterJoints(SeparateCharacterResult)
  }
  
  func DelegateReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
      default:
        return .none
      }
    }
  }
}
