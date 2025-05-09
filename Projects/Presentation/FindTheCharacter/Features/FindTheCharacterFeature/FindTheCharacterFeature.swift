//
//  FindTheCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import SwiftUI
import SharedProvider
import DomainModels
import NetworkProvider
import CropImageFeatures

@Reducer
public struct FindTheCharacterFeature {
  public init() {}

  @Dependency(ADNetworkProvider.self) var makeADProvider
  @Dependency(ADInfoProvider.self) var adInfo
  @Dependency(StepProvider.self) var step
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    InnerReducer()
    AsyncReducer()
    ScopeReducer()
    DelegateReducer()
    UpdateReducer()
  }
}

public extension FindTheCharacterFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ViewAction, InnerAction, AsyncAction, ScopeAction, DelegateAction, UpdateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case inner(InnerActions)
    case async(AsyncActions)
    case scope(ScopeActions)
    case delegate(DelegateActions)
    case update(UpdateActions)
  }
}

extension FindTheCharacterFeature {
  func MainReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.cropImage, action: \.scope.cropImage) {
      CropImageFeature()
    }
  }
}
