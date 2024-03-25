//
//  FindingTheCharacterDelegateAction.swift
//  FindingTheCharacterFeatures
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import FindingTheCharacterInterfaces

public extension FindingTheCharacterFeature {
  enum DelegateActions: Equatable {
    case moveToSeparatingCharacter(FindingTheCharacterResult)
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
