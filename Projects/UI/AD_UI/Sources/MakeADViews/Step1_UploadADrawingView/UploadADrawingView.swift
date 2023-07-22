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
  typealias MyStore = UploadADrawingStore
  let store: StoreOf<MyStore>
  
  init(
    store: StoreOf<MyStore> = Store(
      initialState: MyStore.State(
        sharedState: SharedState(),
        state: UploadADrawingStore.MyState()
      ),
      reducer: MyStore()
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView(viewStore.binding(\.sharedState.$isShowStepStatusBar)) {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList {
            CheckListContent(with: viewStore)
          }
          
          UploadButton(
            state: viewStore.uploadState) {
              viewStore.send(.uploadAction)
            }
          
          SampleDrawings(with: viewStore)
          
          Spacer()
        }
        .padding()
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
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description1 = "Make sure the character is drawn on a white piece of paper without lines, wrinkles, or tears"
    let description2 = "Make sure the drawing is well lit. To minimize shadows, hold the camera further away and zoom in on the drawing."
    let description3 = "Don’t include any identifiable information, offensive content (see our community standards), or drawings that infringe on the copyrights of others."
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description1, state: viewStore.binding(\.$checkState1)) {
        viewStore.send(.checkAction1)
      }
      
      CheckListButton(description2, state: viewStore.binding(\.$checkState2)) {
        viewStore.send(.checkAction2)
      }
      
      // MARK: "(see our community standards)" 링크추가
      CheckListButton(description3, state: viewStore.binding(\.$checkState3)) {
        viewStore.send(.checkAction3)
      }
    }
  }
}

extension UploadADrawingView {
  struct TestUploadButton: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    let photoFill = "photo.fill"
    let text = "Upload Photo"
    
    var body: some View {
      PhotosPicker(
        selection: $selectedItem,
        photoLibrary: .shared()) {
          HStack {
            Image(systemName: photoFill)
            Text(text)
          }
        }
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func UploadButton(
    state: Bool,
    action: @escaping () -> ()
  ) -> some View {
    let photoFill = "photo.fill"
    let text = "Upload Photo"
    
    ADButton(
      state ? .active : .inActive,
      action: action
    ) {
      HStack {
        Image(systemName: photoFill)
        Text(text)
      }
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func SampleDrawings(with viewStore: MyViewStore) -> some View {
    SampleDrawingsDescription()
    SampleImages(with: viewStore)
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
  
  @ViewBuilder
  func SampleImages(with viewStore: MyViewStore) -> some View {
    let sample = ADUtilsAsset.SampleDrawing.self
    let example1: ADUtilsImages = sample.example1
    let example2: ADUtilsImages = sample.example2
    let example3: ADUtilsImages = sample.example3
    let example4: ADUtilsImages = sample.example4
    let imageCardAction: (ADUtilsImages) -> () = { image in
      viewStore.send(.sampleTapAction(image.image))
    }
    
    VStack(spacing: 20) {
      HStack(spacing: 20) {
        ImageCardButton(image: example1) {
          imageCardAction(example1)
        }
        
        ImageCardButton(image: example2) {
          imageCardAction(example2)
        }
      }
      HStack(spacing: 20) {
        ImageCardButton(image: example3) {
          imageCardAction(example3)
        }
        ImageCardButton(image: example4) {
          imageCardAction(example4)
        }
      }
    }
    .frame(height: 450)
  }
  
  @ViewBuilder
  func ImageCardButton(
    image: ADUtilsImages,
    action: @escaping () -> ()
  ) -> some View {
    Button(action: action) {
      image.swiftUIImage
        .resizable()
        .mask {
          RoundedRectangle(cornerRadius: 15)
        }
    }
  }
}

struct UploadADrawingView_Previews: PreviewProvider {
  static var previews: some View {
    UploadADrawingView()
  }
}
