//
//  MaskableView.swift
//  MaskingImage
//
//  Created by chminii on 1/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import MaskImageFeatures
import ADResources

struct MaskableView: View {
  @State private var imageFrame: CGRect = .init()
  private let backgroundImage: UIImage = ADResourcesAsset.SampleDrawing.checkerboard.image
  let croppedImage: UIImage
  let maskedImage: UIImage
  
  init(
    croppedImage: UIImage,
    maskedImage: UIImage
  ) {
    self.croppedImage = croppedImage
    self.maskedImage = maskedImage
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 15)
      .foregroundColor(.white)
      .shadow(radius: 10)
      .overlay {
        Image(uiImage: backgroundImage)
          .resizable()
          .overlay {
            MaskableUIViewRepresentable(
              imageFrame: $imageFrame,
              croppedImage: croppedImage,
              initMaskImage: maskedImage
            )
          }
          .background(
            GeometryReader { geo in
              Color.clear
                .onAppear {
                  self.imageFrame = geo.frame(in: .global)
                }
            }
          )
          .padding()
      }
      .padding()
      .padding(.bottom)
  }
}
