//
//  MockCropImageView.swift
//  CropImageExample
//
//  Created by chminii on 3/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitResources
import CoreModel
import ADComposableArchitecture
import CropImageFeatures

struct MockCropImageView: View {
  let store: StoreOf<CropImageFeature>
  @State var isPresentedCropResultView = false
  
  init() {
    let originalImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
    let boundingBox: CGRect = BoundingBoxDTO.mock().toCGRect()
    self.store = Store(
      initialState: .init(
        originalImage: originalImage,
        boundingBox: boundingBox
      )
    ) {
      CropImageFeature()
    }
  }
  
  var body: some View {
    CropImageView(store: store)
  }
}
