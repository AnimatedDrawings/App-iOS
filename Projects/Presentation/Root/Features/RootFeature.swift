//
//  RootFeature.swift
//  RootFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ConfigureAnimationFeatures
import MakeADFeatures
import SharedProvider

@Reducer
public struct RootFeature {
  @Dependency(ADViewStateProvider.self) var adview
  @Dependency(StepProvider.self) var step

  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(state: \.makeAD, action: \.scope.makeAD) {
      MakeADFeature()
    }
    Scope(state: \.configureAnimation, action: \.scope.configureAnimation) {
      ConfigureAnimationFeature()
    }
    MainReducer()
    ViewReducer()
    ScopeReducer()
    UpdateReducer()
  }
}

extension RootFeature {
  @CasePathable
  public enum Action: Equatable, ViewAction, ScopeAction, UpdateAction {
    case view(ViewActions)
    case scope(ScopeActions)
    case update(UpdateActions)
  }
}

extension RootFeature {
  public func MainReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
