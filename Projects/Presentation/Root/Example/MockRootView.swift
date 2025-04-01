//
//  MockRootView.swift
//  RootExample
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import NetworkProvider
import RootFeatures
import SharedProvider
import SwiftUI

struct MockRootView: View {
  @Bindable var store: StoreOf<RootFeature>

  init() {
    let state = RootFeature.State()
    store = Store(initialState: state) {
      RootFeature()
        .dependency(
          ADViewStateProvider(currentView: .ConfigureAnimation)
        )
        .dependency(\.adNetworkProvider, ADNetworkProvider.testValue)
    }
  }

  var body: some View {
    RootView(store: store)
  }
}
