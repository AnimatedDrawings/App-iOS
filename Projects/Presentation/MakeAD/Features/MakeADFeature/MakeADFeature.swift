//
//  MakeADFeature.swift
//  MakeADFeatures
//
//  Created by chminii on 2/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UploadADrawingFeatures
import FindingTheCharacterFeatures

@Reducer
public struct MakeADFeature {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.uploadADrawing, action: \.scope.uploadADrawing) {
      UploadADrawingFeature()
    }
    .onChange(of: \.uploadADrawing.stepBar) { _, stepBar in
      Reduce { state, action in
        state.stepBar = stepBar
        return .none
      }
    }
    Scope(state: \.findTheCharacter, action: \.scope.findingTheCharacter) {
      FindingTheCharacterFeature()
    }
    .onChange(of: \.findTheCharacter.stepBar) { _, stepBar in
      Reduce { state, action in
        state.stepBar = stepBar
        return .none
      }
    }
    
    BindingReducer()
    MainReducer()
      .onChange(of: \.stepBar) { _, stepBar in
        Reduce { state, action in
          state.uploadADrawing.stepBar = stepBar
          state.findTheCharacter.stepBar = stepBar
          return .none
        }
      }
    UploadADrawingReducer()
    FindTheCharacterReducer()
  }
}

public extension MakeADFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ScopeAction {
    case binding(BindingAction<State>)
    case scope(ScopeActions)
  }
  
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      default:
        return .none
      }
    }
  }
}
