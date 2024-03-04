//
//  MockViewFinder.swift
//  CropImageExample
//
//  Created by chminii on 1/31/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitResources
import CoreModel

struct MockViewFinder: View {
  let example1: UIImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
  let boundingBox: CGRect = BoundingBoxDTO.mock().toCGRect()
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
