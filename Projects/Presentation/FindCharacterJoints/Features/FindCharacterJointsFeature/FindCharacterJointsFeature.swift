//
//  FindCharacterJointsFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ModifyJointsFeatures
import NetworkProvider
import SharedProvider

@Reducer
public struct FindCharacterJointsFeature {
  public init() {}
  
  @Dependency(ADNetworkProvider.self) var makeADProvider
  @Dependency(ADInfoProvider.self) var adInfo
  @Dependency(StepProvider.self) var step
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    ScopeReducer()
    InnerReducer()
    AsyncReducer()
    DelegateReducer()
    UpdateReducer()
  }
}

public extension FindCharacterJointsFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ViewAction, ScopeAction, InnerAction, AsyncAction, UpdateAction, DelegateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case scope(ScopeActions)
    case inner(InnerActions)
    case async(AsyncActions)
    case delegate(DelegateActions)
    case update(UpdateActions)
  }
}

public extension FindCharacterJointsFeature {
  func MainReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      default:
        return .none
      }
    }
    .ifLet(\.modifyJoints, action: \.scope.modifyJoints) {
      ModifyJointsFeature()
    }
  }
}
