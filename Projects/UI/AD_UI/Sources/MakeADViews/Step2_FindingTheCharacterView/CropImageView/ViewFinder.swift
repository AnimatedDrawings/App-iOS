//
//  ViewFinder.swift
//  AD_UI
//
//  Created by minii on 2023/06/06.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct ViewFinder: View {
  let originalImage: UIImage
  //  @Binding var cropRect: CGRect
  //  @Binding var imageScale: CGFloat
  @ObservedObject var boundingBoxInfo: BoundingBoxInfo
  
  init(originalImage: UIImage, boundingBoxInfo: BoundingBoxInfo) {
    self.originalImage = originalImage
    self.boundingBoxInfo = boundingBoxInfo
  }
  
  //  init(
  //    originalImage: UIImage,
  //    cropRect: Binding<CGRect>,
  //    imageScale: Binding<CGFloat>
  //  ) {
  //    self.originalImage = originalImage
  //    self._cropRect = cropRect
  //    self._imageScale = imageScale
  //  }
  
  var body: some View {
    VStack {
      Image(uiImage: originalImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .overlay {
          GeometryReader { geo in
            //            let cgRect: CGRect = geo.frame(in: .local)
            //
            //            GridView(initRect: cgRect, cropRect: $cropRect)
            //              .onAppear {
            //                self.cropRect = cgRect
            //                self.imageScale = cgRect.size.width == 0 ? 0 : self.originalImage.size.width / cgRect.size.width
            //              }
            
            
//            GridView(
//              initRect: self.boundingBoxInfo.initRect,
//              cropRect: self.$boundingBoxInfo.cropRect
//            )
            GridView(
              initRect: self.boundingBoxInfo.initRect,
              cropRect: self.$boundingBoxInfo.cropRect,
              viewSize: self.boundingBoxInfo.viewSize
            )
            .onAppear {
              let cgRect: CGRect = geo.frame(in: .local)
              self.boundingBoxInfo.cropRect = cgRect
              self.boundingBoxInfo.viewSize = cgRect
              self.boundingBoxInfo.imageScale = cgRect.size.width == 0 ?
              0 :
              self.originalImage.size.width / cgRect.size.width
            }
          }
        }
    }
    .padding(.horizontal)
  }
}

//struct TestViewFinder: View {
//  let image: UIImage = ADUtilsAsset.SampleDrawing.garlic.image
//  @StateObject var boundingBoxInfo = BoundingBoxInfo(
//    boundingBoxDTO: BoundingBoxInfo(
//      boundingBoxDTO: <#T##BoundingBoxDTO#>
//    )
//  )
//  @State var cropRect: CGRect = .init()
//  @State var imageScale: CGFloat = 0
//
//  var body: some View {
////    ViewFinder(originalImage: image, cropRect: $cropRect, imageScale: $imageScale)
//    ViewFinder(originalImage: image, boundingBoxInfo: )
//  }
//}
//
//struct ViewFinder_Previews: PreviewProvider {
//  static var previews: some View {
//    TestViewFinder()
//  }
//}
