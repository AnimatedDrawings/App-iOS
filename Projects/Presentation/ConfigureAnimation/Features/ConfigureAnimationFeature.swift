//
//  ConfigureAnimationFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import Foundation
import LocalFileProvider
import NetworkProvider
import SharedProvider
import AdmobManager

@Reducer
public struct ConfigureAnimationFeature {
  @Dependency(StepProvider.self) var step
  @Dependency(ADViewStateProvider.self) var adViewState
  @Dependency(ADInfoProvider.self) var adInfo
  @Dependency(ADNetworkProvider.self) var configureAnimationProvider
  @Dependency(LocalFileProvider.self) var localFileProvider

  let admobManager = AdmobManagerImpl()

  public init() {}

  public enum Action: Equatable, BindableAction, ViewAction, InnerAction, DelegateAction,
    AsyncAction
  {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case inner(InnerActions)
    case delegate(DelegateActions)
    case async(AsyncActions)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    InnerReducer()
    DelegateReducer()
    AsyncReducer()
  }
}

extension ConfigureAnimationFeature {
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
