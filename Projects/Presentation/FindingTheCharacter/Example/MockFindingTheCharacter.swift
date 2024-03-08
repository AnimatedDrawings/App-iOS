//
//  MockFindingTheCharacter.swift
//  FindingTheCharacterTestings
//
//  Created by chminii on 1/30/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
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
    let originalImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
    let boundingBox = BoundingBoxDTO.mock().toCGRect()
    let cropImageState = CropImageFeature.State(
      originalImage: originalImage,
      boundingBox: boundingBox
    )
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
      .onAppear {
        if store.cropImage == nil {
          print("store cropImage nil??")
        }
      }
  }
}
