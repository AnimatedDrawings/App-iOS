//
//  RootView.swift
//  AD_UI
//
//  Created by minii on 2023/06/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import RootFeatures
import OnBoarding
import MakeAD
import ConfigureAnimation

public struct RootView: View {
  @Perception.Bindable var store: StoreOf<RootFeature>
  
  public init(
    store: StoreOf<RootFeature> = Store(initialState: .init()) {
      RootFeature()
    }
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      ZStack {
        switch store.adViewState {
        case .OnBoarding:
          OnBoardingView()
        case .MakeAD:
          MakeADView(
            store: store.scope(
              state: \.makeAD,
              action: \.scope.makeAD
            )
          )
        case .ConfigureAnimation:
          ConfigureAnimationView(
            store: store.scope(
              state: \.configureAnimation,
              action: \.scope.configureAnimation
            )
          )
        }
      }
    }
    .task { await store.send(.view(.task)).finish() }
  }
}
