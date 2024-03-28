//
//  MockMaskImageView.swift
//  MaskImageExample
//
//  Created by chminii on 3/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADResources
import ADComposableArchitecture
import MaskImageFeatures

struct MockMaskImageView: View {
  @Perception.Bindable var store: StoreOf<MaskImageFeature>
  
  init() {
    let croppedImage: UIImage = ADResourcesAsset.TestImages.croppedImage.image
    let maskedImage: UIImage = ADResourcesAsset.TestImages.maskedImage.image
    
    self.store = Store(
      initialState: .init(
        croppedImage: croppedImage,
        maskedImage: maskedImage
      )
    ) {
      MaskImageFeature()
    }
  }
  
  var body: some View {
    MaskImageView(store: store)
  }
}
