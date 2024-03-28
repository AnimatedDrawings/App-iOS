//
//  MockMaskImageView.swift
//  MaskImageExample
//
//  Created by chminii on 3/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADResources

struct MockMaskImageView: View {
  let croppedImage: UIImage = ADResourcesAsset.TestImages.croppedImage.image
  let initMaskImage: UIImage = ADResourcesAsset.TestImages.maskedImage.image
  
  var body: some View {
    MaskImageView(croppedImage: croppedImage, initMaskImage: initMaskImage)
  }
}
