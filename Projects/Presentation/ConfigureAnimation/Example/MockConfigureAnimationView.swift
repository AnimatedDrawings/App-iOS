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
import ADResources

struct MockConfigureAnimationView: View {
  @Bindable var store: StoreOf<ConfigureAnimationFeature>
  
  init() {
    let gifData = ADResourcesAsset.ADAnimation.dab.data.data
    let state: ConfigureAnimationFeature.State = .init(
      currentAnimation: .init(data: gifData, url: .init(filePath: ""))
    )
    store = Store(initialState: state) {
      ConfigureAnimationFeature()
    }
  }
  
  var body: some View {
    ConfigureAnimationView(store: store)
  }
}
