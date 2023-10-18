//
//  UploadADrawingView.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKit
import ThirdPartyLib
import UploadADrawingFeatures
import PhotosUI
import DomainModel
import SharedProvider

public struct UploadADrawingView: ADUI {
  public typealias MyFeature = UploadADrawingFeature

  public init(
    store: MyStore = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.store = store
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  let store: MyStore
  @StateObject var viewStore: MyViewStore
  
  public var body: some View {
    ADScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        
        CheckList(myStep: .UploadADrawing) {
          CheckListContent(viewStore: viewStore)
        }
        
        UploadButton(state: viewStore.$isEnableUploadButton) { imageData in
          viewStore.send(.uploadDrawing(imageData))
        }
        
        SampleDrawings { imageData in
          viewStore.send(.uploadDrawing(imageData))
        }
        
        Spacer()
      }
      .padding()
    }
    .fullScreenOverlay(presentationSpace: .named("UploadADrawingView")) {
      if viewStore.state.isShowLoadingView {
        LoadingView(description: "Uploading Drawing...")
          .transparentBlurBackground(
            effect: UIBlurEffect(style: .light),
            intensity: 0.3
          )
      }
    }
    .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
    .receiveShared(\.shared.trashMode) { trash in
      viewStore.send(.initState)
    }
  }
}

private extension UploadADrawingView {
  struct Title: View {
    let title = "UPLOAD A DRAWING"
    let left = "Upload a drawing of"
    let one = " ONE "
    let right = "character, where the arms and legs don’t overlap the body (see examples below)."
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADUIKitAsset.Color.blue2.swiftUIColor)
        
        Text(left) + Text(one).fontWeight(.bold) + Text(right)
      }
    }
  }
}

private extension UploadADrawingView {
  struct CheckListContent: View {
    @ObservedObject var viewStore: MyViewStore
    
    let description1 = "Make sure the character is drawn on a white piece of paper without lines, wrinkles, or tears"
    let description2 = "Make sure the drawing is well lit. To minimize shadows, hold the camera further away and zoom in on the drawing."
    let description3 = "Don’t include any identifiable information, offensive content (see our community standards), or drawings that infringe on the copyrights of others."
    let myStep: Step = .UploadADrawing
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description1,
          state: viewStore.$checkState1,
          myStep: myStep
        ) {
          viewStore.send(.checkList1)
        }
        
        CheckListButton(
          description: description2,
          state: viewStore.$checkState2,
          myStep: myStep
        ) {
          viewStore.send(.checkList2)
        }
        
        CheckListButton(
          description: description3,
          state: viewStore.$checkState3,
          myStep: myStep
        ) {
          viewStore.send(.checkList3)
        }
      }
    }
  }
}

private extension UploadADrawingView {
  struct UploadButton: View {
    @Binding var state: Bool
    let uploadImageAction: (Data?) -> ()
    
    init(
      state: Binding<Bool>,
      uploadImageAction: @escaping (Data?) -> ()
    ) {
      self._state = state
      self.uploadImageAction = uploadImageAction
    }
    
    let photoFill = "photo.fill"
    let text = "Upload Photo"
    
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
      PhotosPicker(
        selection: $selectedItem,
        photoLibrary: .shared(),
        label: {
          ADButtonLabel(state) {
            HStack {
              Image(systemName: photoFill)
              Text(text)
            }
          }
        }
      )
      .allowsHitTesting(state)
      .onChange(of: selectedItem) { newValue in
        _Concurrency.Task {
          let data = try? await newValue?.loadTransferable(type: Data.self)
          uploadImageAction(data)
        }
      }
    }
  }
}

private extension UploadADrawingView {
  struct SampleDrawings: View {
    let tapCardAction: (Data?) -> ()
    
    var body: some View {
      VStack {
        Description()
        Samples(tapCardAction: tapCardAction)
      }
    }
    
    @ViewBuilder
    func Description() -> some View {
      let leftTitle = "S A M P L E"
      let rightTitle = "D R A W I N G S"
      let description = "Feel free to try the demo by clicking on one of the following example images."
      
      VStack(alignment: .leading, spacing: 15) {
        HStack(spacing: 15) {
          Text(leftTitle)
            .font(.system(.title3, weight: .semibold))
          Text(rightTitle)
            .font(.system(.title3, weight: .semibold))
        }
        Text(description)
      }
    }
    
    struct Samples: View {
      let tapCardAction: (Data?) -> ()
      
      typealias sample = ADUIKitAsset.SampleDrawing
      let example1: ADUIKitImages = sample.step1Example1
      let example2: ADUIKitImages = sample.step1Example2
      let example3: ADUIKitImages = sample.step1Example3
      let example4: ADUIKitImages = sample.step1Example4
      
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
      func ImageCardButton(image sample: ADUIKitImages) -> some View {
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
}

// MARK: - Previews
struct UploadADrawingView_Previews: PreviewProvider {
  static var previews: some View {
    UploadADrawingView()
  }
}
