//
//  ViewFinder.swift
//  AD_UI
//
//  Created by minii on 2023/06/06.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct ViewFinder: View {
  let originalImage: UIImage
  @ObservedObject var boundingBoxInfo: BoundingBoxInfo
  
  init(originalImage: UIImage, boundingBoxInfo: BoundingBoxInfo) {
    self.originalImage = originalImage
    self.boundingBoxInfo = boundingBoxInfo
  }
  
  var body: some View {
    Image(uiImage: originalImage)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .background(
        GeometryReader { geo in
          Color.clear
            .onAppear {
              let cgRect: CGRect = geo.frame(in: .local)
              self.boundingBoxInfo.viewSize = cgRect
              self.boundingBoxInfo.imageScale = self.originalImage.size.width != 0 ?
              cgRect.size.width / self.originalImage.size.width :
              0
            }
        }
      )
      .overlay {
        GridView(boundingBoxInfo: _boundingBoxInfo)
      }
  }
}
