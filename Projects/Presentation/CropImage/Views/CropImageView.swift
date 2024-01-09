//
//  CropImageView.swift
//  AD_UI
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitSources
import ADUIKitResources
import CropImageFeatures
import ThirdPartyLib

public struct CropImageView: ADUI {
  public typealias MyFeature = CropImageFeature
  
  let store: MyStore
  @StateObject var viewStore: MyViewStore
  
  let originalImage: UIImage
  let cropNextAction: (UIImage?, CGRect) -> ()

  @State var resetTrigger = false
  @StateObject var boundingBoxInfo: BoundingBoxInfo
  
  public init(
    originalImage: UIImage,
    originCGRect: CGRect,
    cropNextAction: @escaping (UIImage?, CGRect) -> Void,
    store: MyStore = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.originalImage = originalImage
    self.cropNextAction = cropNextAction
    self._boundingBoxInfo = StateObject(
      wrappedValue: BoundingBoxInfo(
        originCGRect: originCGRect
      )
    )
    
    self.store = store
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  public var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(
        cancelAction: { viewStore.send(.cancelAction) },
        saveAction: { save() }
      )
      
      Spacer()
  
      ViewFinder(
        originalImage: originalImage,
        boundingBoxInfo: boundingBoxInfo
      )
      .padding()
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
  func save() {
    let croppedImage = self.cropImage()
    let croppedCGRect = self.boundingBoxInfo.getCroppedCGRect()
    
    cropNextAction(croppedImage, croppedCGRect)
  }
  
  func cropImage() -> UIImage? {
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
    let strokeColor = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
    
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

// MARK: - Previews_CropImageView

struct Previews_CropImageView: View {
  let originalImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.garlic.image
  let originCGRect: CGRect = .init(origin: .init(x: 100, y: 100), size: .init(width: 200, height: 200))
  
  @State var isPresentedCropResultView = false
  @State var croppedUIImage: UIImage = .init()
  @State var croppedCGRect: CGRect = .init()
  
  var body: some View {
    NavigationStack {
      VStack {
        CropImageView(
          originalImage: originalImage,
          originCGRect: originCGRect) { croppedUIImage, croppedCGRect in
            if let croppedUIImage = croppedUIImage {
              self.croppedUIImage = croppedUIImage
              self.croppedCGRect = croppedCGRect
              self.isPresentedCropResultView.toggle()
            }
          }
      }
      .navigationDestination(isPresented: $isPresentedCropResultView) {
        Previews_CropResultView(croppedUIImage: self.croppedUIImage, croppedCGRect: self.croppedCGRect)
      }
    }
  }
}

struct Previews_CropResultView: View {
  let croppedUIImage: UIImage
  let croppedCGRect: CGRect
  
  var body: some View {
    VStack {
      Text("x : \(croppedCGRect.origin.x), y : \(croppedCGRect.origin.y)")
      Text("width : \(croppedCGRect.width), height : \(croppedCGRect.height)")
      
      Rectangle()
        .frame(width: 300, height: 400)
        .foregroundColor(.red)
        .overlay {
          Image(uiImage: croppedUIImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
    }
  }
}

struct CropImageView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_CropImageView()
  }
}
