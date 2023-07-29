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
    let croppedImage = self.crop()
    let boundingBoxDTO = self.boundingBoxInfo.toBoundingBoxDTO()
    let cropResult = CropResult(
      croppedImage: croppedImage,
      boundingBoxDTO: boundingBoxDTO
    )
    cropAction(cropResult)
  }
  
  func crop() -> UIImage? {
    let reciprocal: CGFloat = 1 / self.boundingBoxInfo.imageScale
    
    let cropCGSize = CGSize(
      width: self.boundingBoxInfo.croppedRect.size.width * reciprocal,
      height: self.boundingBoxInfo.croppedRect.size.height * reciprocal
    )
    
    let cropCGPoint = CGPoint(
      x: -self.boundingBoxInfo.croppedRect.origin.x * reciprocal,
      y: -self.boundingBoxInfo.croppedRect.origin.y * reciprocal
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
//  let originalImage: UIImage = ADUtilsAsset.SampleDrawing.garlic.image
//  let boundingBoxDTO: BoundingBoxDTO = .mock()
//  
//  var body: some View {
//    CropImageView(
//      originalImage: originalImage,
//      boundingBoxDTO: <#T##BoundingBoxDTO#>,
//      cropAction: <#T##(CropResult) -> ()#>,
//      cancelAction: <#T##() -> ()#>
//    )
//  }
//}
//
//struct CropImageView_Previews: PreviewProvider {
//  static var previews: some View {
//    Previews_CropImageView()
//  }
//}
