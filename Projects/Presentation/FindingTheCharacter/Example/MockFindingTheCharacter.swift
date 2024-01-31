//
//  MockFindingTheCharacter.swift
//  FindingTheCharacterTestings
//
//  Created by chminii on 1/30/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import FindingTheCharacter
import FindingTheCharacterFeatures
import ThirdPartyLib
import SharedProvider
import ADUIKitResources
import DomainModel
import NetworkProvider

struct MockFindingTheCharacter: ADUI {
  @SharedValue(\.shared.stepBar.completeStep) var completeStep
  @SharedValue(\.shared.makeAD.originalImage) var originalImage
  @SharedValue(\.shared.makeAD.boundingBox) var boundingBox
  @SharedValue(\.shared.makeAD.ad_id) var ad_id
  
  typealias MyFeature = FindingTheCharacterFeature
  let store: MyStore
  
  init() {
    let feature = withDependencies {
      $0.makeADProvider = .previewValue
    } operation: {
      MyFeature()
    }

    self.store = Store(initialState: .init()) {
      feature
    }
  }
  
  var body: some View {
    FindingTheCharacterView(store: store)
      .onAppear {
        self.ad_id = "ad_id"
        self.completeStep = .UploadADrawing
        self.originalImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
        self.boundingBox = UploadDrawingResult.example1Mock().boundingBox
      }
  }
}

#Preview {
  MockFindingTheCharacter()
}
