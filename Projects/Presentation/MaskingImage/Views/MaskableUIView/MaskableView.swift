//
//  MaskableView.swift
//  MaskingImage
//
//  Created by chminii on 1/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import MaskingImageFeatures
import ADUIKitResources

struct MaskableView: View {
  @State private var imageFrame: CGRect = .init()
  private let backgroundImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.checkerboard.image
  
  let croppedImage: UIImage
  let initMaskImage: UIImage
  
  @ObservedObject var viewStore: ViewStoreOf<MaskingImageFeature>
  
  init(
    croppedImage: UIImage,
    initMaskImage: UIImage,
    viewStore: ViewStoreOf<MaskingImageFeature>
  ) {
    self.croppedImage = croppedImage
    self.initMaskImage = initMaskImage
    self.viewStore = viewStore
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
              myFrame: imageFrame,
              croppedImage: croppedImage,
              initMaskImage: initMaskImage,
              viewStore: viewStore
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


// MARK: - Preview

struct Preview_MaskableView: View {
  let croppedImage: UIImage = ADUIKitResourcesAsset.TestImages.croppedImage.image
  let initMaskImage: UIImage = ADUIKitResourcesAsset.TestImages.maskedImage.image
  @State var maskedImage: UIImage? = nil
  
  @StateObject var viewStore: ViewStoreOf<MaskingImageFeature>
  
  init() {
    let store: StoreOf<MaskingImageFeature> = Store(
      initialState: MaskingImageFeature.State(
        drawingState: .erase,
        circleRadius: 20,
        maskedImage: nil
      )
    ) {
      MaskingImageFeature()
    }
    self._viewStore = StateObject(wrappedValue: ViewStore(store, observe: { $0 }))
  }
  
  var body: some View {
    MaskableView(
      croppedImage: croppedImage,
      initMaskImage: initMaskImage,
      viewStore: viewStore
    )
  }
}

#Preview {
  Preview_MaskableView()
}
