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
import SharedProvider

struct MockFindCharacterJointsView: View {
  @Perception.Bindable var store: StoreOf<FindCharacterJointsFeature>
  
  init() {
    let state: FindCharacterJointsFeature.State = .init(modifyJoints: .mock())
    let store = Store(initialState: state) {
      FindCharacterJointsFeature()
        .dependency(
          ADInfoProvider.init(
            id: "0f7976d201554961af5526467e6a6ce2_20240416051517"
          )
        )
        .dependency(
          StepProvider.init(
            isShowStepBar: true,
            currentStep: .FindCharacterJoints,
            completeStep: .SeparateCharacter
          )
        )
    }
    self.store = store
  }
  
  var body: some View {
    FindingCharacterJointsView(store: store)
  }
}
