////
////  MaskImageView.swift
////  MaskImage
////
////  Created by minii on 2023/07/04.
////
//
//import SwiftUI
//import Combine
//import ADUIKitSources
//import ADUIKitResources
//import ADComposableArchitecture
//import MaskingImageFeatures
//
//public struct MaskingImageView: ADUI {
//  public typealias MyFeature = MaskingImageFeature
//  
//  let store: MyStore
//  let viewStore: MyViewStore
//  
//  let croppedImage: UIImage
//  let initMaskImage: UIImage
//  
//  let backgroundImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.checkerboard.image
//  @State var imageFrame: CGRect = .init()
//  
//  public init(
//    store: MyStore,
//    croppedImage: UIImage,
//    initMaskImage: UIImage
//  ) {
//    self.store = store
//    self.viewStore = ViewStore(store, observe: { $0 })
//    self.croppedImage = croppedImage
//    self.initMaskImage = initMaskImage
//  }
//  
//  public var body: some View {
//    VStack(spacing: 20) {
//      ToolNaviBar(
//        cancelAction: viewStore.action(.cancelAction),
//        saveAction: viewStore.action(.saveAction)
//      )
//      .padding()
//      
//      Spacer()
//      
//      MaskableView(
//        croppedImage: croppedImage,
//        initMaskImage: initMaskImage,
//        viewStore: viewStore
//      )
//      
//      Spacer()
//      
//      MaskToolView(viewStore: viewStore)
//    }
//  }
//}

import SwiftUI
import ADComposableArchitecture
import ADUIKit
import MaskImageFeatures

public struct MaskImageView: View {
  @Perception.Bindable var store: StoreOf<MaskImageFeature>
  
  public init(store: StoreOf<MaskImageFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 20) {
      ToolNaviBar(
        cancelAction: {},
        saveAction: {}
      )
      .padding()
      
      Spacer()
      
      MaskableView(
        croppedImage: store.croppedImage,
        maskedImage: store.maskedImage
      )
      
      Spacer()
      
//      MaskToolView(toolCircleSize: $store.curCircleRadius)
      MaskToolView(store: store)
    }
  }
}
