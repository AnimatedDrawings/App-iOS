//
//  MockViewFinder.swift
//  CropImageExample
//
//  Created by chminii on 1/31/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitSources
import ADUIKitResources
import DomainModel
import CropImageFeatures
import SharedProvider
import ThirdPartyLib

#Preview {
  MockViewFinder()
}

struct MockViewFinder: ADUI {
  typealias MyFeature = CropImageFeature
  let store: MyStore
  @StateObject var viewStore: MyViewStore
  @SharedValue(\.shared.makeAD.originalImage) var originalImage
  @SharedValue(\.shared.makeAD.boundingBox) var boundingBox
  
  init() {
    let store = Store(initialState: .init()) {
      MyFeature()
    }
    self.store = store
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  var body: some View {
    ViewFinder(cropImageViewStore: viewStore)
      .onAppear {
        originalImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
        boundingBox = UploadDrawingResult.example1Mock().boundingBox
      }
  }
}
