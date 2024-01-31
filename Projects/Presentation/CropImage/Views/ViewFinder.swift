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
  @State var originalImage = UIImage()
  
  init(cropImageViewStore: ViewStoreOf<CropImageFeature>) {
    self.cropImageViewStore = cropImageViewStore
  }
  
  @State var test = false
  
  var body: some View {
    GeometryReader { geo in
      let viewArea: CGRect = geo.frame(in: .local)
      
      Image(uiImage: originalImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .receiveShared(\.shared.makeAD.originalImage) { image in
          guard let image = image else { return }
          self.originalImage = image
          
          cropImageViewStore.send(.initViewSize(viewArea))
          let imageScale = getImageScale(imageSize: originalImage.size, viewSize: viewArea.size)
          cropImageViewStore.send(.initImageScale(imageScale))
        }
        .overlay {
          GridView(cropImageViewStore: cropImageViewStore)
        }
    }
  }
}

extension ViewFinder {
  func getImageScale(imageSize: CGSize, viewSize: CGSize) -> CGFloat {
    return imageSize.width != 0 ? viewSize.width / imageSize.width : 0
  }
}
