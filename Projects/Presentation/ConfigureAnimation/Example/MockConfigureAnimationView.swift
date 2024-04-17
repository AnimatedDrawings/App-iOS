//
//  MockConfigureAnimationView.swift
//  ConfigureAnimationExample
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import ConfigureAnimationFeatures

struct MockConfigureAnimationView: View {
  @Perception.Bindable var store: StoreOf<ConfigureAnimationFeature>
  
  init() {
    store = Store(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  }
  
  var body: some View {
    ConfigureAnimationView(store: store)
  }
}
