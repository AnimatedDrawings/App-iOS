//
//  UploadADrawingView.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture
import PhotosUI

struct UploadADrawingView: ADUI {
  typealias MyFeature = UploadADrawingFeature
  let store: StoreOf<MyFeature>
  
  init(
    store: StoreOf<MyFeature> = rootViewStore.scope(
      state: \.uploadADrawingState,
      action: RootViewFeature.Action.uploadADrawingAction
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView(
        viewStore.binding(
          get: \.sharedState.isShowStepStatusBar,
          send: MyFeature.Action.bindIsShowStepStatusBar
        )
      ) {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList {
            CheckListContent(with: viewStore)
          }
          
          UploadButton(viewStore.isEnableUploadButton) { imageData in
            viewStore.send(.uploadDrawing(imageData))
          }
          
          SampleDrawings { imageData in
            //            viewStore.send(.uploadDrawing(imageData))
            let garlicData = ADUtilsAsset.SampleDrawing.garlic.image.pngData()
            viewStore.send(.uploadDrawing(garlicData))
          }
          
          Spacer()
        }
        .padding()
      }
      .fullScreenOverlay(presentationSpace: .named("UploadADrawingView")) {
        if viewStore.state.uploadProcess {
          LoadingView(description: "Uploading Drawing...")
            .transparentBlurBackground(
              effect: UIBlurEffect(style: .light),
              intensity: 0.3
            )
        }
      }
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func Title() -> some View {
    let title = "UPLOAD A DRAWING"
    let left = "Upload a drawing of"
    let one = " ONE "
    let right = "character, where the arms and legs don’t overlap the body (see examples below)."
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(left) + Text(one).fontWeight(.bold) + Text(right)
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  @MainActor
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description1 = "Make sure the character is drawn on a white piece of paper without lines, wrinkles, or tears"
    let description2 = "Make sure the drawing is well lit. To minimize shadows, hold the camera further away and zoom in on the drawing."
    let description3 = "Don’t include any identifiable information, offensive content (see our community standards), or drawings that infringe on the copyrights of others."
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description1, state: viewStore.$checkState1) {
        viewStore.send(.checkList1)
      }
      
      CheckListButton(description2, state: viewStore.$checkState2) {
        viewStore.send(.checkList2)
      }
      
      CheckListButton(description3, state: viewStore.$checkState3) {
        viewStore.send(.checkList3)
      }
    }
  }
}

extension UploadADrawingView {
  struct UploadButton: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    var state: Bool
    var uploadImageAction: (Data?) -> ()
    let photoFill = "photo.fill"
    let text = "Upload Photo"
    
    var buttonState: ADButtonState {
      self.state == true ? .active : .inActive
    }
    
    init(_ state: Bool,
         uploadImageAction: @escaping (Data?) -> ()
    ) {
      self.state = state
      self.uploadImageAction = uploadImageAction
    }
    
    var body: some View {
      PhotosPicker(
        selection: $selectedItem,
        photoLibrary: .shared(),
        label: {
          ADButtonLabel(buttonState) {
            HStack {
              Image(systemName: photoFill)
              Text(text)
            }
          }
        }
      )
      .onChange(of: selectedItem) { newItem in
        Task {
          let data = try? await newItem?.loadTransferable(type: Data.self)
          uploadImageAction(data)
        }
      }
      .allowsHitTesting(self.state)
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func SampleDrawings(tapCardAction: @escaping (Data?) -> ()) -> some View {
    SampleDrawingsDescription()
    SampleImages(tapCardAction: tapCardAction)
  }
  
  @ViewBuilder
  func SampleDrawingsDescription() -> some View {
    let leftTitle = "S A M P L E"
    let rightTitle = "D R A W I N G S"
    let description = "Feel free to try the demo by clicking on one of the following example images."
    
    VStack(alignment: .leading, spacing: 15) {
      HStack(spacing: 15) {
        Text(leftTitle)
          .font(.system(.title3, weight: .medium))
        Text(rightTitle)
          .font(.system(.title3, weight: .medium))
      }
      Text(description)
    }
  }
  
  struct SampleImages: View {
    let tapCardAction: (Data?) -> ()
    
    typealias sample = ADUtilsAsset.SampleDrawing
    let example1: ADUtilsImages = sample.example1
    let example2: ADUtilsImages = sample.example2
    let example3: ADUtilsImages = sample.example3
    let example4: ADUtilsImages = sample.example4
    
    var body: some View {
      VStack(spacing: 20) {
        HStack(spacing: 20) {
          ImageCardButton(image: example1)
          ImageCardButton(image: example2)
        }
        HStack(spacing: 20) {
          ImageCardButton(image: example3)
          ImageCardButton(image: example4)
        }
      }
      .frame(height: 450)
    }
    
    @ViewBuilder
    func ImageCardButton(image sample: ADUtilsImages) -> some View {
      Button {
        tapCardAction(sample.image.pngData())
      } label: {
        sample.swiftUIImage
          .resizable()
          .mask {
            RoundedRectangle(cornerRadius: 15)
          }
      }
    }
  }
}

struct UploadADrawingView_Previews: PreviewProvider {
  static var previews: some View {
    UploadADrawingView()
  }
}
