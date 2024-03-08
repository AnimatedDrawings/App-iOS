//
//  FindingTheCharacterFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import SwiftUI
import SharedProvider
import DomainModel
import NetworkProvider
import CropImageFeatures

@Reducer
public struct FindingTheCharacterFeature {
  public init() {}

  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.adInfo.id) var ad_id
  @Dependency(StepProvider.self) var step
  
  public var body: some Reducer<State, Action> {
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

public extension FindingTheCharacterFeature {
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

extension FindingTheCharacterFeature {
  func MainReducer() -> some Reducer<State, Action> {
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
