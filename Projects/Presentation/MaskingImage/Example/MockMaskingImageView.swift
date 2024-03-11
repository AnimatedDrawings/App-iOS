//
//  MockMaskingImageView.swift
//  MaskingImageExample
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import MaskingImage
import ADUIKitResources

struct MockMaskingImageView: View {
  let croppedImage: UIImage = ADUIKitResourcesAsset.TestImages.croppedImage.image
  let initMaskImage: UIImage = ADUIKitResourcesAsset.TestImages.maskedImage.image
  
  @State var isPresentedMaskResultView: Bool = false
  @State var maskedImage: UIImage? = nil
  
  let store: StoreOf<MaskingImageFeature>
  
  init() {
    self.store = Store(initialState: .init()) { MaskingImageFeature() }
  }
  
  var body: some View {
    MaskingImageView(
      store: store,
      croppedImage: croppedImage,
      initMaskImage: initMaskImage
    )
    .receiveShared(\.shared.makeAD.maskedImage) { maskedImage in
      self.maskedImage = maskedImage
      self.isPresentedMaskResultView.toggle()
    }
    .sheet(isPresented: $isPresentedMaskResultView) {
      Previews_MaskResultView(maskedImage: maskedImage)
    }
  }
}

//struct Previews_MaskResultView: View {
//  let maskedImage: UIImage?
//  
//  var body: some View {
//    if let maskedImage = maskedImage {
//      Rectangle()
//        .frame(width: 300, height: 400)
//        .foregroundColor(.red)
//        .overlay {
//          Image(uiImage: maskedImage)
//            .resizable()
//        }
//    }
//  }
//}
//
//struct MaskableView_Previews: PreviewProvider {
//  static var previews: some View {
//    Previews_MaskingImageView()
//  }
//}
