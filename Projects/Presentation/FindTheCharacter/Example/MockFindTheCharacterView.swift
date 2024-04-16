//
//  MockFindTheCharacterView.swift
//  FindTheCharacterExample
//
//  Created by chminii on 4/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import FindTheCharacterFeatures
import ADResources
import SharedProvider

struct MockFindTheCharacterView: View {
  @Perception.Bindable var store: StoreOf<FindTheCharacterFeature>
  
  init() {
    let state: FindTheCharacterFeature.State = .init(
      cropImage: .init(
        originalImage: ADResourcesAsset.TestImages.originalImage.image,
        boundingBox: .mock()
      )
    )
    let store: StoreOf<FindTheCharacterFeature> = Store(initialState: state) {
      FindTheCharacterFeature()
        .dependency(
          ADInfoProvider.init(
            id: "0f7976d201554961af5526467e6a6ce2_20240416051517"
          )
        )
        .dependency(
          StepProvider.init(
            isShowStepBar: true,
            currentStep: .FindTheCharacter,
            completeStep: .UploadDrawing
          )
        )
    }
    self.store = store
  }
  
  var body: some View {
    FindTheCharacterView(store: store)
  }
}
