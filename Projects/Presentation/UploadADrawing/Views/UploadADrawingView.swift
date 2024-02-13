//
//  UploadADrawingView.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitSources
import ADUIKitResources
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
        
        CheckList(
          myStep: .UploadADrawing,
          completeStep: viewStore.stepBar.completeStep
        ) {
          CheckListContent(viewStore: viewStore)
        }
        
        UploadButton(state: viewStore.isEnableUploadButton) { imageData in
          viewStore.send(.uploadDrawing(imageData))
        }
        
        SampleDrawings { imageData in
          viewStore.send(.uploadDrawing(imageData))
        }
        
        Spacer()
      }
      .padding()
    }
    .alertNetworkError(isPresented: viewStore.$isShowNetworkErrorAlert)
    .alertFindCharacterError(isPresented: viewStore.$isShowFindCharacterErrorAlert)
    .alertimageSizeError(isPresented: viewStore.$isShowImageSizeErrorAlert)
    .fullScreenOverlay(presentationSpace: .named("UploadADrawingView")) {
      if viewStore.state.isShowLoadingView {
        LoadingView(description: "Uploading Drawing...")
          .transparentBlurBackground(
            effect: UIBlurEffect(style: .light),
            intensity: 0.3
          )
      }
    }
    .resetMakeADView(.UploadADrawing) {
      viewStore.send(.initState)
    }
  }
}

extension View {
  func alertFindCharacterError(
    isPresented: Binding<Bool>
  ) -> some View {
    self.alert(
      "Cannot Find Character",
      isPresented: isPresented,
      actions: {
        Button("OK", action: {})
      },
      message: {
        Text("Please check the image you uploaded confirming the checklist content or Please use a different picture with a clear character")
      }
    )
  }
  
  func alertimageSizeError(
    isPresented: Binding<Bool>
  ) -> some View {
    self.alert(
      "The image size is too big",
      isPresented: isPresented,
      actions: {
        Button("OK", action: {})
      },
      message: {
        Text("Please use file type of image and size 10MB or less")
      }
    )
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
          .foregroundColor(ADUIKitResourcesAsset.Color.blue2.swiftUIColor)
        
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
    let description4 = "Please use file type of image and size 10MB or less"
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description1,
          state: viewStore.binding(
            get: \.checkState.check1,
            send: .check(.list1)
          )
        )
        
        CheckListButton(
          description: description2,
          state: viewStore.binding(
            get: \.checkState.check2,
            send: .check(.list2)
          )
        )
        
        CheckListButton(
          description: description3,
          state: viewStore.binding(
            get: \.checkState.check3,
            send: .check(.list3)
          )
        )
        
        CheckListButton(
          description: description4,
          state: viewStore.binding(
            get: \.checkState.check4,
            send: .check(.list4)
          )
        )
      }
    }
  }
}

private extension UploadADrawingView {
//  class UploadButtonViewModel: ObservableObject {
//    let uploadImageAction: (Data?) -> ()
//    
//    init(uploadImageAction: @escaping (Data?) -> Void) {
//      self.uploadImageAction = uploadImageAction
//    }
//    
//    @Published var selectedItem: PhotosPickerItem? = nil {
//      didSet {
//        setImage(from: selectedItem)
//      }
//    }
//    
//    private func setImage(from selectedItem: PhotosPickerItem?) {
//      if let selectedItem = selectedItem {
//        Task {
//          let data = try? await selectedItem.loadTransferable(type: Data.self)
//          uploadImageAction(data)
//          self.selectedItem = nil
//        }
//      }
//    }
//  }
  
  struct UploadButton: View {
    let state: Bool
    let uploadImageAction: (Data?) -> Void
    
    @State var selectedItem: PhotosPickerItem? = nil
    
    init(
      state: Bool,
      uploadImageAction: @escaping (Data?) -> ()
    ) {
      self.state = state
      self.uploadImageAction = uploadImageAction
    }
    
    let photoFill = "photo.fill"
    let text = "Upload Photo"

    var body: some View   {
      PhotosPicker(
        selection: $selectedItem,
        matching: .images,
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
      .onChange(of: selectedItem, perform: setImage(from:))
    }
    
    private func setImage(from selectedItem: PhotosPickerItem?) {
      if let selectedItem = selectedItem {
        Task {
          let data = try? await selectedItem.loadTransferable(type: Data.self)
          uploadImageAction(data)
          self.selectedItem = nil
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
    
    struct Description: View {
      let leftTitle = "S A M P L E"
      let rightTitle = "D R A W I N G S"
      let description = "Feel free to try the demo by clicking on one of the following example images."
      
      var body: some View {
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
    }
    
    struct Samples: View {
      let tapCardAction: (Data?) -> ()
      
      typealias sample = ADUIKitResourcesAsset.SampleDrawing
      let example1: ADUIKitResourcesImages = sample.step1Example1
      let example2: ADUIKitResourcesImages = sample.step1Example2
      let example3: ADUIKitResourcesImages = sample.step1Example3
      let example4: ADUIKitResourcesImages = sample.step1Example4
      
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
      func ImageCardButton(image sample: ADUIKitResourcesImages) -> some View {
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

#Preview {
  UploadADrawingView()
}
