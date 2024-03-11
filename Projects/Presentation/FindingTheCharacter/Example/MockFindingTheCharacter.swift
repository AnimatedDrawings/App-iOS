//
//  MockFindingTheCharacter.swift
//  FindingTheCharacterTestings
//
//  Created by chminii on 1/30/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import FindingTheCharacterFeatures
import CropImageFeatures
import ADUIKitResources
import SharedProvider
import CoreModel

struct MockFindingTheCharacterView: View {
  @Dependency(StepProvider.self) var step
  let store: StoreOf<FindingTheCharacterFeature>
  let cropImageState: CropImageFeature.State
  
  init() {
    let cropImageState = CropImageFeature.State.mock()
    let store: StoreOf<FindingTheCharacterFeature> = Store(
      initialState: FindingTheCharacterFeature.State(
        cropImage: cropImageState
      )
    ) {
      FindingTheCharacterFeature()
    }
    
    self.store = store
    self.cropImageState = cropImageState
  }
  
  var body: some View {
    FindingTheCharacterView(store: store)
      .task {
        await step.completeStep.set(.UploadADrawing)
      }
  }
}
