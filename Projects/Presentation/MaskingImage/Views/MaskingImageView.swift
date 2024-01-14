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
import ThirdPartyLib
import MaskingImageFeatures

public struct MaskingImageView: ADUI {
  public typealias MyFeature = MaskingImageFeature
  
  let store: MyStore
  let viewStore: MyViewStore
  
  let croppedImage: UIImage
  let initMaskImage: UIImage
  
  let backgroundImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.checkerboard.image
  @State var imageFrame: CGRect = .init()
  
  public init(
    store: MyStore,
    croppedImage: UIImage,
    initMaskImage: UIImage
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
    self.croppedImage = croppedImage
    self.initMaskImage = initMaskImage
  }
  
  public var body: some View {
    VStack(spacing: 20) {
      ToolNaviBar(
        cancelAction: viewStore.action(.cancelAction),
        saveAction: viewStore.action(.saveAction)
      )
      .padding()
      
      Spacer()
      
      MaskableView(
        croppedImage: croppedImage,
        initMaskImage: initMaskImage,
        viewStore: viewStore
      )
      
      Spacer()
      
      MaskToolView(viewStore: viewStore)
    }
  }
}


// MARK: - Previews

#Preview {
  Previews_MaskingImageView()
}

struct Previews_MaskingImageView: View {
  let croppedImage: UIImage = ADUIKitResourcesAsset.TestImages.croppedImage.image
  let initMaskImage: UIImage = ADUIKitResourcesAsset.TestImages.maskedImage.image
  
  @State var isPresentedMaskResultView: Bool = false
  @State var maskedImage: UIImage? = nil
  
  let store: StoreOf<MaskingImageFeature>
  
  init() {
    self.store = Store(initialState: .init()) { MaskingImageFeature() }
  }
  
  var body: some View {
    MaskingImageView(
      store: store,
      croppedImage: croppedImage,
      initMaskImage: initMaskImage
    )
    .receiveShared(\.shared.makeAD.maskedImage) { maskedImage in
      self.maskedImage = maskedImage
      self.isPresentedMaskResultView.toggle()
    }
    .sheet(isPresented: $isPresentedMaskResultView) {
      Previews_MaskResultView(maskedImage: maskedImage)
    }
  }
}

struct Previews_MaskResultView: View {
  let maskedImage: UIImage?
  
  var body: some View {
    if let maskedImage = maskedImage {
      Rectangle()
        .frame(width: 300, height: 400)
        .foregroundColor(.red)
        .overlay {
          Image(uiImage: maskedImage)
            .resizable()
        }
    }
  }
}

struct MaskableView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_MaskingImageView()
  }
}

