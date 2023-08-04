//
//  MaskingImageView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/04.
//

import SwiftUI
import Combine
import AD_Utils

struct MaskingImageView: View {
  let croppedImage: UIImage
  let initMaskImage: UIImage
  
  @StateObject private var maskToolState = MaskToolState()
  @StateObject private var maskableViewLink: MaskableViewLink
  
  let backgroundImage: UIImage = ADUtilsAsset.SampleDrawing.checkerboard.image
  @State var imageFrame: CGRect = .init()
  @State var toolSizerButtonOffset: CGFloat = 0
  
  init(
    croppedImage: UIImage,
    initMaskImage: UIImage,
    maskedImage: Binding<UIImage?>,
    maskNextAction: @escaping (Bool) -> (),
    cancelAction: @escaping () -> ()
  ) {
    self.croppedImage = croppedImage
    self.initMaskImage = initMaskImage
    self._maskableViewLink = StateObject(
      wrappedValue: MaskableViewLink(
        maskedImage: maskedImage,
        maskNextAction: maskNextAction,
        cancelAction: cancelAction
      )
    )
  }
  
  var body: some View {
    VStack {
      ToolNaviBar(
        cancelAction: maskableViewLink.cancel,
        saveAction: maskableViewLink.save
      )
      .padding()
      
      Spacer()
      
      Image(uiImage: backgroundImage)
        .resizable()
        .frame(height: 450)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                self.imageFrame = geo.frame(in: .global)
              }
          }
        )
        .overlay {
          MaskableUIViewRepresentable(
            myFrame: imageFrame,
            croppedImage: croppedImage,
            initMaskImage: initMaskImage,
            maskToolState: maskToolState,
            maskableViewLink: maskableViewLink
          )
        }
        .padding()
      
      Spacer()
      Spacer()
        .frame(height: abs(toolSizerButtonOffset))
      
      MaskToolView(
        maskToolState: maskToolState,
        toolSizerButtonOffset: $toolSizerButtonOffset
      )
    }
  }
}

// MARK: - Previews
struct Previews_MaskingImageView: View {
  let croppedImage: UIImage = ADUtilsAsset.Garlic.texture.image
  let initMaskImage: UIImage = ADUtilsAsset.Garlic.maskedImg.image
  @State var maskedImage: UIImage? = nil
  @State var isNewMaskedImage = false
  
  var body: some View {
    MaskingImageView(
      croppedImage: croppedImage,
      initMaskImage: initMaskImage,
      maskedImage: $maskedImage,
      maskNextAction: { _ in },
      cancelAction: {}
    )
  }
}

struct MaskableView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_MaskingImageView()
  }
}

