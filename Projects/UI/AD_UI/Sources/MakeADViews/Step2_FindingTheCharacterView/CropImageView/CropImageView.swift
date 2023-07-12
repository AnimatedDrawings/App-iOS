//
//  CropImageView.swift
//  AD_UI
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils

struct CropImageView: View {
  let originalImage: UIImage
  @Binding var croppedImage: UIImage?
  let cropNextAction: (Bool) -> ()
  let cancelAction: () -> ()
  
  @State var cropRect: CGRect = .init()
  @State var imageScale: CGFloat = 0
  
  let toolBarHeight: CGFloat = 40
  
  @State var reset = false
  
  init(
    originalImage: UIImage,
    croppedImage: Binding<UIImage?>,
    cropNextAction: @escaping (Bool) -> (),
    cancelAction: @escaping () -> ()
  ) {
    self.originalImage = originalImage
    self._croppedImage = croppedImage
    self.cropNextAction = cropNextAction
    self.cancelAction = cancelAction
  }
  
  var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(
        height: toolBarHeight,
        cancelAction: cancel,
        saveAction: save
      )
      
      Spacer()
      
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
      .id(reset)
      
      Spacer()
      
      HStack {
        Spacer()
        ResetButton()
      }
    }
    .padding()
  }
}

extension CropImageView {
  func cancel() {
    cancelAction()
  }
}

extension CropImageView {
  func save() {
    let cropResult = crop()
    cropNextAction(cropResult)
  }
  
  func crop() -> Bool {
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
    
    if let croppedImage = UIGraphicsGetImageFromCurrentImageContext() {
      UIGraphicsEndImageContext()
      self.croppedImage = croppedImage
      return true
    }
    
    return false
  }
}

extension CropImageView {
  @ViewBuilder
  func ResetButton() -> some View {
    let size: CGFloat = 60
    let imageName = "arrow.uturn.backward"
    let strokeColor = ADUtilsAsset.Color.blue1.swiftUIColor
    
    Button(action: resetAction) {
      Circle()
        .frame(width: size, height: size)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          Image(systemName: imageName)
            .resizable()
            .foregroundColor(strokeColor)
            .fontWeight(.semibold)
            .padding()
        }
    }
  }
  
  func resetAction() {
    self.reset.toggle()
  }
}

struct Previews_CropImageView: View {
  let image: UIImage = ADUtilsAsset.SampleDrawing.garlic.image
  @State var croppedImage: UIImage? = nil
  @State var isShowCropImageView: Bool = false
  
  var body: some View {
    ZStack {
      ADBackground()
        .blur(radius: 4)
      
      CropImageView(
        originalImage: image,
        croppedImage: $croppedImage,
        cropNextAction: { _ in print("cropped and upload!") },
        cancelAction: {}
      )
    }
  }
}

struct CropImageView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_CropImageView()
  }
}
