//
//  SeparateCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import SharedProvider
import NetworkProvider
import MaskImageFeatures

@Reducer
public struct SeparateCharacterFeature {
  public init() {}
  
  @Dependency(ADNetworkProvider.self) var makeADProvider
  @Dependency(ADInfoProvider.self) var adInfo
  @Dependency(StepProvider.self) var step
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    UpdateReducer()
    InnerReducer()
    ScopeReducer()
    AsyncReducer()
    DelegateReducer()
  }
}

public extension SeparateCharacterFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ViewAction, UpdateAction, InnerAction, ScopeAction, AsyncAction, DelegateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case update(UpdateActions)
    case inner(InnerActions)
    case scope(ScopeActions)
    case async(AsyncActions)
    case delegate(DelegateActions)
  }
}

public extension SeparateCharacterFeature {
  func MainReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      default:
        return .none
      }
    }
    .ifLet(\.maskImage, action: \.scope.maskImage) {
      MaskImageFeature()
    }
  }
}
