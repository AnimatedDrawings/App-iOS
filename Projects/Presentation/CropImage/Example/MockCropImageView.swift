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
    let originalImage: UIImage = ADResourcesAsset.TestImages.example2.image
    let boundingBox: BoundingBox = .mockExample2()
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
