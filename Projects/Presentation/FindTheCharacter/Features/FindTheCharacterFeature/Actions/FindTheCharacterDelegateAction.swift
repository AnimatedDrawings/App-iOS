//
//  FindTheCharacterDelegateAction.swift
//  FindTheCharacterFeatures
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import FindTheCharacterInterfaces

public extension FindTheCharacterFeature {
  enum DelegateActions: Equatable {
    case moveToSeparateCharacter(FindTheCharacterResult)
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
