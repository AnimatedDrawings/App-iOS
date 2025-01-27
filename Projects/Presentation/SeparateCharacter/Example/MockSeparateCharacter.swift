//
//  MockSeparateCharacter.swift
//  SeparateCharacterExample
//
//  Created by chminii on 4/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import SeparateCharacterFeatures
import ADResources
import SharedProvider

struct MockSeparateCharacter: View {
  @Bindable var store: StoreOf<SeparateCharacterFeature>
  
  init() {
    let state: SeparateCharacterFeature.State = .init(maskImage: .mock())
    let store: StoreOf<SeparateCharacterFeature> = Store(initialState: state) {
      SeparateCharacterFeature()
        .dependency(
          ADInfoProvider.init(
            id: "0f7976d201554961af5526467e6a6ce2_20240416051517"
          )
        )
        .dependency(
          StepProvider.init(
            isShowStepBar: true,
            currentStep: .SeparateCharacter,
            completeStep: .FindTheCharacter
          )
        )
    }
    self.store = store
  }
  
  var body: some View {
    SeparateCharacterView(store: store)
  }
}
