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
    Scope(state: \.findTheCharacter, action: \.scope.findingTheCharacter) {
      FindingTheCharacterFeature()
    }
    
    BindingReducer()
    MainReducer()
      .onChange(of: \.stepBar.completeStep) { oldValue, newValue in
        Reduce { state, action in
          state.uploadADrawing.completeStep = newValue
          state.findTheCharacter.completeStep = newValue
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
