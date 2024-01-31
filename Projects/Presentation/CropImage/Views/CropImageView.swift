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
//  let cropNextAction: (UIImage?, CGRect) -> ()
  
  @State var resetTrigger = false
  
  public init(store: MyStore) {
    self.store = store
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  public var body: some View {
    VStack(spacing: 40) {
      ToolNaviBar(
        cancelAction: { cancel() },
        saveAction: { save() }
      )
      
      Spacer()
      
      ViewFinder(cropImageViewStore: viewStore)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .shadow(radius: 10)
        )
        .reload(viewStore.resetTrigger)
      
      Spacer()
      
      HStack {
        Spacer()
        ResetButton {
          viewStore.send(.reset)
        }
      }
    }
    .padding()
  }
}

extension CropImageView {
  func cancel() {
    viewStore.send(.cancel)
  }
  
  func save() {
    viewStore.send(.save)
//    cropNextAction(viewStore.croppedImage, viewStore.croppedCGRect)
  }
}

extension CropImageView {
  struct ResetButton: View {
    let size: CGFloat = 60
    let imageName = "arrow.uturn.backward"
    let strokeColor = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
    let action: () -> ()
    
    var body: some View {
      Button(action: action) {
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
  }
}


// MARK: - Previews_CropImageView

struct Previews_CropImageView: View {
  let originalImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.garlic.image
  let originCGRect: CGRect = .init(x: 100, y: 100, width: 500, height: 800)
  
  @State var isPresentedCropResultView = false
  @State var croppedUIImage: UIImage = .init()
  @State var croppedCGRect: CGRect = .init()
  
  var body: some View {
    NavigationStack {
      VStack {
        CropImageView(
          store: Store(
            initialState: CropImageFeature.State(),
            reducer: { CropImageFeature() }
          )
        )
      }
      .navigationDestination(isPresented: $isPresentedCropResultView) {
        Previews_CropResultView(
          croppedUIImage: self.croppedUIImage,
          croppedCGRect: self.croppedCGRect
        )
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
