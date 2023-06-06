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
  @State var cropRect: CGRect = .init()
  
  init(originalImage: UIImage = ADUtilsAsset.SampleDrawing.garlic.image) {
    self.originalImage = originalImage
  }
  
  var body: some View {
    VStack {
      GeometryReader { proxy in
        let cgRect: CGRect = proxy.frame(in: .local)
        
        Image(uiImage: originalImage)
          .resizable()
          .onAppear {
            self.cropRect = cgRect
          }
          .overlay {
            CropImageView(initRect: cgRect, cropRect: $cropRect)
          }
      }
    }
    .padding(.horizontal, 20)
    .frame(height: 400)
  }
}
