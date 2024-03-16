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
  let example1: UIImage = ADResourcesAsset.TestImages.example2.image
  let boundingBox: BoundingBox = .mockExample2()
  @State var viewBoundingBox: CGRect = .init()
  @State var imageScale: CGFloat = 1
  
  var body: some View {
    ViewFinder(
      image: example1,
      boundingBox: boundingBox,
      viewBoundingBox: $viewBoundingBox,
      imageScale: $imageScale
    )
  }
}
