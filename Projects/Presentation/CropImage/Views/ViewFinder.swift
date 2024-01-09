//
//  ViewFinder.swift
//  AD_UI
//
//  Created by minii on 2023/06/06.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import CropImageFeatures
import SharedProvider

struct ViewFinder: View {
  @ObservedObject var cropImageViewStore: ViewStoreOf<CropImageFeature>
  @SharedValue(\.shared.makeAD.originalImage) var originalImage
  
  init(cropImageViewStore: ViewStoreOf<CropImageFeature>) {
    self.cropImageViewStore = cropImageViewStore
  }
  
  var body: some View {
    let originalImage: UIImage = self.originalImage ?? UIImage()
    
    Image(uiImage: originalImage)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .background(
        GeometryReader { geo in
          Color.clear
            .onAppear {
              let cgRect: CGRect = geo.frame(in: .local)
              cropImageViewStore.send(.initViewSize(cgRect))
              let imageScale = originalImage.size.width != 0 ?
              cgRect.size.width / originalImage.size.width :
              0
              cropImageViewStore.send(.initImageScale(imageScale))
            }
        }
      )
      .overlay {
        GridView(cropImageViewStore: cropImageViewStore)
      }
  }
}
