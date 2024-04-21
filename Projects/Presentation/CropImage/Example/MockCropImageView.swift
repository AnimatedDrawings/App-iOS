//
//  MockCropImageView.swift
//  CropImageExample
//
//  Created by chminii on 3/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADResources
import DomainModels
import ADComposableArchitecture
import CropImageFeatures

struct MockCropImageView: View {
  let store: StoreOf<CropImageFeature>
  @State var isPresentedCropResultView = false
  
  init() {
    let originalImage: UIImage = ADResourcesAsset.TestImages.originalImage.image
    let imageBoundingBox: BoundingBox = .mock()
//    let originalImage: UIImage = ADResourcesAsset.SampleDrawing.step1Example2.image
//    let imageBoundingBox: BoundingBox = .init(cgRect: .init(x: 178.0, y: 207.0, width: 1464.0, height: 2469.0))
    self.store = Store(
      initialState: .init(
        originalImage: originalImage,
        imageBoundingBox: imageBoundingBox
      )
    ) {
      CropImageFeature()
    }
  }
  
  var body: some View {
    CropImageView(store: store)
  }
}
