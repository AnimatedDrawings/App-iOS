//
//  MockRootView.swift
//  RootExample
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import RootFeatures
import ADComposableArchitecture
import SharedProvider

struct MockRootView: View {
  @Bindable var store: StoreOf<RootFeature>
  
  init() {
    let state = RootFeature.State(
      makeAD: .init(uploadDrawing: .init(
        check: .init(list1: true, list2: true, list3: false, list4: true)
      )))
    store = Store(initialState: state) {
      RootFeature()
        .dependency(
          ADViewStateProvider(currentView: .ConfigureAnimation)
        )
    }
  }
  
  var body: some View {
    RootView(store: store)
  }
}
