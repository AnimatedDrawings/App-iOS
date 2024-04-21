//
//  MockViewFinder.swift
//  CropImageExample
//
//  Created by chminii on 1/31/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADResources
import DomainModels

struct MockViewFinder: View {
  let originalImage: UIImage = ADResourcesAsset.TestImages.originalImage.image
  let imageBoundingBox: BoundingBox = .mock()
  @State var viewBoundingBox: CGRect = .init()
  @State var imageScale: CGFloat = 1
  
  var body: some View {
    ViewFinder(
      image: originalImage,
      imageBoundingBox: imageBoundingBox,
      viewBoundingBox: $viewBoundingBox,
      imageScale: $imageScale
    )
  }
}
