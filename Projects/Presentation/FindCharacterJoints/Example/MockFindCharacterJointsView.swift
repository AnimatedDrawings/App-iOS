//
//  MockFindCharacterJointsView.swift
//  FindCharacterJointsExample
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import FindCharacterJointsFeatures

struct MockFindCharacterJointsView: View {
  @Perception.Bindable var store: StoreOf<FindCharacterJointsFeature>
  
  init() {
    let state: FindCharacterJointsFeature.State = .init()
    let store = Store(initialState: state) {
      FindCharacterJointsFeature()
    }
    self.store = store
  }
  
  var body: some View {
    FindingCharacterJointsView(store: store)
  }
}
