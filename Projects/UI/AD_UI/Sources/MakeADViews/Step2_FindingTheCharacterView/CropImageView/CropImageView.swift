//
//  CropImageView.swift
//  AD_UI
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct CropImageView: View {
  let originalImage: UIImage
  @Binding var croppedImage: UIImage?
  let cropNextAction: () -> ()
  @State var cropRect: CGRect = .init()
  @State var imageScale: CGFloat = 0
  
  init(
    originalImage: UIImage,
    croppedImage: Binding<UIImage?>,
    cropNextAction: @escaping () -> ()
  ) {
    self.originalImage = originalImage
    self._croppedImage = croppedImage
    self.cropNextAction = cropNextAction
  }
  
  var body: some View {
    VStack(spacing: 40) {
      ViewFinder(
        originalImage: originalImage,
        cropRect: $cropRect,
        imageScale: $imageScale
      )
      .padding(.vertical, 15)
      .background(
        RoundedRectangle(cornerRadius: 15)
          .foregroundColor(.white)
          .shadow(radius: 10)
      )
      
      CropButton()
    }
    .padding()
  }
}

extension CropImageView {
  @ViewBuilder
  func CropButton() -> some View {
    ADButton("Next", action: cropButtonAction)
  }
  
  func cropButtonAction() {
    let cropCGSize = CGSize(
      width: cropRect.size.width * imageScale,
      height: cropRect.size.height * imageScale
    )
    
    let cropCGPoint = CGPoint(
      x: -cropRect.origin.x * imageScale,
      y: -cropRect.origin.y * imageScale
    )
    
    UIGraphicsBeginImageContext(cropCGSize)
    
    self.originalImage.draw(at: cropCGPoint)
    let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.croppedImage = croppedImage
    
    cropNextAction()
  }
}

struct PreviewsCropImageView: View {
  let image: UIImage = ADUtilsAsset.SampleDrawing.garlic.image
  @State var croppedImage: UIImage? = nil
  
  var body: some View {
    CropImageView(
      originalImage: image,
      croppedImage: $croppedImage,
      cropNextAction: { print("cropped and upload!") }
    )
  }
}

struct CropImageView_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsCropImageView()
  }
}
