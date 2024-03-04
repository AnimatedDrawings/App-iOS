//
//  ViewFinder.swift
//  AD_UI
//
//  Created by minii on 2023/06/06.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct ViewFinder: View {
  let image: UIImage
  let boundingBox: CGRect
  @Binding var viewBoundingBox: CGRect
  @Binding var imageScale: CGFloat
  
  @State var viewSize: CGSize = .init()
  @State var initalBoundingBox: CGRect = .init()
  
  var body: some View {
    ImageView(
      image: image,
      viewSize: $viewSize
    )
    .onChange(of: viewSize, perform: updateFrameGridView)
    .overlay {
      GridView(
        initalBoundingBox: $initalBoundingBox,
        viewSize: viewSize,
        updateBoundingBox: { boundingBox in
          viewBoundingBox = boundingBox
        }
      )
    }
  }
}

extension ViewFinder {
  struct ImageView: View {
    let image: UIImage
    @Binding var viewSize: CGSize
    
    var body: some View {
      ZStack {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .background(
            GeometryReader { geo in
              Color.clear
                .onAppear {
                  self.viewSize = geo.frame(in: .local).size
                }
            }
          )
      }
    }
  }
}

extension ViewFinder {
  func updateFrameGridView(_ viewSize: CGSize) {
    imageScale = calImageScale(viewSize: viewSize)
    let boundingOrigin = CGPoint(
      x: boundingBox.minX * imageScale,
      y: boundingBox.minY * imageScale
    )
    let boundingSize = CGSize(
      width: boundingBox.width * imageScale,
      height: boundingBox.height * imageScale
    )
    
    initalBoundingBox = CGRect(origin: boundingOrigin, size: boundingSize)
  }
  
  func calImageScale(viewSize: CGSize) -> CGFloat {
    let imageSizeValue: CGFloat = image.size.width
    let viewSizeValue: CGFloat = viewSize.width
    return imageSizeValue != 0 ? viewSizeValue / imageSizeValue : 0
  }
}
