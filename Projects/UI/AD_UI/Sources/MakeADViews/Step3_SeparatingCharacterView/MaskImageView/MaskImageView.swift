//
//  MaskImageView.swift
//  AD_UI
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct MaskImageView: View {
  let croppedImage: UIImage
  let verticalInset: CGFloat = 20
  
  init(croppedImage: UIImage = ADUtilsAsset.SampleDrawing.example1.image) {
    self.croppedImage = croppedImage
  }
  
  var body: some View {
    VStack(spacing: verticalInset) {
      VStack(spacing: verticalInset) {
        Image(uiImage: croppedImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
        
      }
      .background(
        RoundedRectangle(cornerRadius: 10)
          .foregroundColor(.gray.opacity(0.1))
      )
      
      HStack {
        ADButton("Previous", .inActive) {
          print("previous..")
        }
        
        ADButton("Next") {
          print("mask image")
        }
      }
    }
    .padding()
  }
}

struct MaskToolView: View {
  let strokeColor: Color = ADUtilsAsset.Color.blue1.swiftUIColor
  
  var body: some View {
    HStack {
      MaskTool()
        .frame(width: 50, height: 50)
      
      Spacer()
      
      MaskTool()
        .frame(width: 50, height: 50)
    }
    .padding()
    .background(
      Color.white.shadow(radius: 10)
    )
  }
}

extension MaskToolView {
  @ViewBuilder
  func MaskTool() -> some View {
    RoundedRectangle(cornerRadius: 10)
      .stroke(strokeColor, lineWidth: 1)
  }
}

struct MaskImageView_Previews: PreviewProvider {
  static var previews: some View {
    MaskImageView()
  }
}
