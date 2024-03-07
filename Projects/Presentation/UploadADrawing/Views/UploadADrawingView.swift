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

public struct UploadADrawingView: View {
  @Perception.Bindable var store: StoreOf<UploadADrawingFeature>

  public init(
    store: StoreOf<UploadADrawingFeature> = Store(initialState: .init()) {
      UploadADrawingFeature()
    }
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      ADScrollView($store.step.isShowStepBar.sending(\.update.setIsShowStepBar)) {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList(
            myStep: .UploadADrawing,
            completeStep: store.step.completeStep
          ) {
            CheckListContent(store: store)
          }
          
          UploadButton(state: store.uploadButton) { imageData in
            store.send(.view(.uploadDrawing(imageData)))
          }
          
          SampleDrawings { imageData in
            store.send(.view(.uploadDrawing(imageData)))
          }
          
          Spacer()
        }
        .padding()
      }
      .alertNetworkError(isPresented: $store.alert.networkError)
      .alertFindCharacterError(isPresented: $store.alert.findCharacterError)
      .alertimageSizeError(isPresented: $store.alert.imageSizeError)
      .fullScreenOverlay(presentationSpace: .named("UploadADrawingView")) {
        if store.loadingView {
          LoadingView(description: "Uploading Drawing...")
            .transparentBlurBackground(
              effect: UIBlurEffect(style: .light),
              intensity: 0.3
            )
        }
      }
      .resetMakeADView(.UploadADrawing) {
        store.send(.view(.initState))
      }
      .task {
        await store.send(.update(.task)).finish()
      }
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
    @Perception.Bindable var store: StoreOf<UploadADrawingFeature>
    
    let description1 = "Make sure the character is drawn on a white piece of paper without lines, wrinkles, or tears"
    let description2 = "Make sure the drawing is well lit. To minimize shadows, hold the camera further away and zoom in on the drawing."
    let description3 = "Don’t include any identifiable information, offensive content (see our community standards), or drawings that infringe on the copyrights of others."
    let description4 = "Please use file type of image and size 10MB or less"
    
    var body: some View {
      WithPerceptionTracking {
        VStack(alignment: .leading, spacing: 15) {
          CheckListButton(
            description: description1,
            state: $store.check.list1.sending(\.view.check.list1)
          )
          
          CheckListButton(
            description: description2,
            state: $store.check.list2.sending(\.view.check.list2)
          )
          
          CheckListButton(
            description: description3,
            state: $store.check.list3.sending(\.view.check.list3)
          )
          
          CheckListButton(
            description: description4,
            state: $store.check.list4.sending(\.view.check.list4)
          )
        }
      }
    }
  }
}

private extension UploadADrawingView {
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
