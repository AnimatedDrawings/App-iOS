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
  let cropAction: (CropResult) -> ()
  let cancelAction: () -> ()
  
//  @State var cropRect: CGRect = .init()
//  @State var imageScale: CGFloat = 0
//
  @State var resetTrigger = false
  @StateObject var boundingBoxInfo: BoundingBoxInfo
  
  init(
    originalImage: UIImage,
    boundingBoxDTO: BoundingBoxDTO,
    cropAction: @escaping (CropResult) -> (),
    cancelAction: @escaping () -> ()
  ) {
    self.originalImage = originalImage
    self._boundingBoxInfo = StateObject(
      wrappedValue: BoundingBoxInfo(
        boundingBoxDTO: boundingBoxDTO
      )
    )
    self.cropAction = cropAction
    self.cancelAction = cancelAction
  }
  
  var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(
        cancelAction: cancel,
        saveAction: save
      )
      
      Spacer()
      
//      ViewFinder(
//        originalImage: originalImage,
//        cropRect: $cropRect,
//        imageScale: $imageScale
//      )
      ViewFinder(
        originalImage: originalImage,
        boundingBoxInfo: boundingBoxInfo
      )
      .padding(.vertical, 15)
      .background(
        RoundedRectangle(cornerRadius: 15)
          .foregroundColor(.white)
          .shadow(radius: 10)
      )
      .reload(resetTrigger)
      
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
    let cropResult = CropResult(crop: self.crop)
    cropAction(cropResult)
  }
  
  func crop() -> UIImage? {
    let cropCGSize = CGSize(
      width: self.boundingBoxInfo.cropRect.size.width * self.boundingBoxInfo.imageScale,
      height: self.boundingBoxInfo.cropRect.size.height * self.boundingBoxInfo.imageScale
    )
    
    let cropCGPoint = CGPoint(
      x: -self.boundingBoxInfo.cropRect.origin.x * self.boundingBoxInfo.imageScale,
      y: -self.boundingBoxInfo.cropRect.origin.y * self.boundingBoxInfo.imageScale
    )
    
    UIGraphicsBeginImageContext(cropCGSize)
    
    self.originalImage.draw(at: cropCGPoint)
    
    guard let croppedImage = UIGraphicsGetImageFromCurrentImageContext() else {
      return nil
    }
    UIGraphicsEndImageContext()
    return croppedImage
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
    self.resetTrigger.toggle()
  }
}

//struct Previews_CropImageView: View {
//  let image: UIImage = ADUtilsAsset.SampleDrawing.garlic.image
//  @State var croppedImage: UIImage? = nil
//  @State var isShowCropImageView: Bool = false
//  
//  var body: some View {
//    ZStack {
//      ADBackground()
//        .blur(radius: 4)
//      
//      CropImageView(
//        originalImage: image,
//        cropAction: { _ in print("cropped and upload!") },
//        cancelAction: {}
//      )
//    }
//  }
//}
//
//struct CropImageView_Previews: PreviewProvider {
//  static var previews: some View {
//    Previews_CropImageView()
//  }
//}
