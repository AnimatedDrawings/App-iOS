//
//  MaskingImageView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/04.
//

import SwiftUI
import Combine
import ADUIKitSources
import ADUIKitResources
import MaskingImageResources
import ThirdPartyLib
import MaskingImageFeatures

public struct MaskingImageView: ADUI {
  public typealias MyFeature = MaskingImageFeature
  
  let store: MyStore
  let viewStore: MyViewStore
  
  let croppedImage: UIImage
  let initMaskImage: UIImage
  
  @StateObject private var maskToolState = MaskToolState()
  @StateObject private var maskableViewLink: MaskableViewLink
  
  let backgroundImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.checkerboard.image
  @State var imageFrame: CGRect = .init()
  @State var toolSizerButtonOffset: CGFloat = 0
  
  public init(
    store: MyStore = Store(initialState: .init()) { MyFeature() },
    croppedImage: UIImage,
    initMaskImage: UIImage,
    maskedImage: Binding<UIImage?>,
    maskNextAction: @escaping (Bool) -> (),
    cancelAction: @escaping () -> ()
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
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
  
  public var body: some View {
    VStack(spacing: 20) {
      ToolNaviBar(
        cancelAction: maskableViewLink.cancel,
        saveAction: maskableViewLink.save
      )
      .padding()
      
      Spacer()
      
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
                maskToolState: maskToolState,
                maskableViewLink: maskableViewLink
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
      
      Spacer()
      
      MaskToolView(
        maskToolState: maskToolState,
        toolSizerButtonOffset: $toolSizerButtonOffset
      )
    }
  }
}

// MARK: - Previews

//#Preview {
//  Previews_MaskingImageView()
//}


//struct Previews_MaskingImageView: View {
//  let croppedImage: UIImage = MaskingImageResourcesAsset.croppedImage.image
//  let initMaskImage: UIImage = MaskingImageResourcesAsset.maskedImage.image
//  
//  @State var maskedImage: UIImage? = nil
//  @State var isPresentedMaskResultView: Bool = false
//  
//  var body: some View {
//    NavigationStack {
//      VStack {
//        MaskingImageView(
//          croppedImage: croppedImage,
//          initMaskImage: initMaskImage,
//          maskedImage: $maskedImage,
//          maskNextAction: { isFinishMaskingImage in
//            if isFinishMaskingImage {
//              if let tmpImageData = self.maskedImage?.pngData() {
//                self.maskedImage = UIImage(data: tmpImageData)
//                self.isPresentedMaskResultView.toggle()
//              }
//            }
//          },
//          cancelAction: {}
//        )
//      }
//      .navigationDestination(isPresented: $isPresentedMaskResultView) {
//        Previews_MaskResultView(maskedImage: $maskedImage)
//      }
//    }
//  }
//}
//
//struct Previews_MaskResultView: View {
//  @Binding var maskedImage: UIImage?
//  
//  var body: some View {
//    if let maskedImage = maskedImage {
//      Rectangle()
//        .frame(width: 300, height: 400)
//        .foregroundColor(.red)
//        .overlay {
//          Image(uiImage: maskedImage)
//            .resizable()
//        }
//    }
//  }
//}
//
//struct MaskableView_Previews: PreviewProvider {
//  static var previews: some View {
//    Previews_MaskingImageView()
//  }
//}

