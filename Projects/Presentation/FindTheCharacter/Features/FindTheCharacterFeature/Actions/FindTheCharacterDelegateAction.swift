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
    case moveToSeparatingCharacter(FindTheCharacterResult)
  }
  
  func DelegateReducer() -> some Reducer<State, Action> {
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
