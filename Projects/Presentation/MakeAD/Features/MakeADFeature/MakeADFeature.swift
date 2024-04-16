//
//  MakeADFeature.swift
//  MakeADFeatures
//
//  Created by chminii on 2/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UploadDrawingFeatures
import FindTheCharacterFeatures
import SeparateCharacterFeatures
import FindCharacterJointsFeatures
import SharedProvider

@Reducer
public struct MakeADFeature {
  @Dependency(StepProvider.self) var step
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.uploadDrawing, action: \.scope.uploadDrawing) {
      UploadDrawingFeature()
    }
    Scope(state: \.findTheCharacter, action: \.scope.findTheCharacter) {
      FindTheCharacterFeature()
    }
    Scope(state: \.separateCharacter, action: \.scope.separateCharacter) {
      SeparateCharacterFeature()
    }
    Scope(state: \.findCharacterJoints, action: \.scope.findCharacterJoints) {
      FindCharacterJointsFeature()
    }
    BindingReducer()
    MainReducer()
    ScopeReducer()
    UpdateReducer()
    ViewReducer()
  }
}

public extension MakeADFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ScopeAction, UpdateAction, ViewAction {
    case binding(BindingAction<State>)
    case scope(ScopeActions)
    case update(UpdateActions)
    case view(ViewActions)
  }
  
  func MainReducer() -> some ReducerOf<Self> {
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
