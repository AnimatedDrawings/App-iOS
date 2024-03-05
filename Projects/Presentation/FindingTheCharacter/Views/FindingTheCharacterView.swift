//
//  FindingTheCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import FindingTheCharacterFeatures
import ADUIKitSources
import ADUIKitResources
import DomainModel
import CropImage

public struct FindingTheCharacterView: View {
  @Perception.Bindable var store: StoreOf<FindingTheCharacterFeature>
  
  public init(
    store: StoreOf<FindingTheCharacterFeature> = Store(
      initialState: .init()
    ) {
      FindingTheCharacterFeature()
    }
  ) {
    self.store = store
  }
  
  public var body: some View {
    ADScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        
        CheckList(myStep: .FindingTheCharacter, completeStep: store.completeStep) {
          CheckListContent(state: $store.checkList)
        }
        
        Spacer()
        
        ShowCropImageViewButton(store.checkList) {
          store.send(.view(.toggleCropImageView))
        }
        
        Spacer().frame(height: 1)
      }
      .padding()
    }
    .alertNoCropImageError(isPresented: $store.alert.noCropImage)
    .fullScreenCover(
      isPresented: $store.cropImageView,
      content: { IfLetCropImageView() }
    )
    .resetMakeADView(.FindingTheCharacter) {
      store.send(.view(.initState))
    }
  }
}

private extension FindingTheCharacterView {
  func IfLetCropImageView() -> some View {
    Group {
      if let cropImageStore = self.store.scope(state: \.cropImage, action: \.scope.cropImage) {
        CropImageView(store: cropImageStore)
          .transparentBlurBackground()
          .addLoadingView(
            isShow: store.loadingView,
            description: "Cropping Image ..."
          )
          .alertNetworkError(isPresented: $store.alert.networkError)
      } else {
        Text("No CropImage..")
      }
    }
  }
}

private extension FindingTheCharacterView {
  struct Title: View {
    let title = "FINDING THE CHARACTER"
    let description = "We’ve identified the character, and put a box around it."
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADUIKitResourcesAsset.Color.blue2.swiftUIColor)
        
        Text(description)
      }
    }
  }
}

private extension FindingTheCharacterView {
  struct CheckListContent: View {
    @Binding var state: Bool
    let description = "Resize the box to ensure it tightly fits one character."
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description,
          state: $state
        )
        
        HStack {
          GIFImage(sample: ADUIKitResourcesAsset.Gifs.step2Gif1)
          GIFImage(sample: ADUIKitResourcesAsset.Gifs.step2Gif2)
        }
        .frame(height: 250)
      }
    }
  }
}

private extension FindingTheCharacterView {
  struct ShowCropImageViewButton: View {
    let viewFinder = "person.fill.viewfinder"
    let text = "Find the Character"
    
    let state: Bool
    let action: () -> ()
    
    init(_ state: Bool, action: @escaping () -> ()) {
      self.state = state
      self.action = action
    }
    
    var body: some View {
      ADButton(
        state: state,
        action: action,
        content: {
          HStack {
            Image(systemName: viewFinder)
            Text(text)
          }
        }
      )
    }
  }
}

private extension View {
  func alertNoCropImageError(
    isPresented: Binding<Bool>
  ) -> some View {
    self.alert(
      "No CropImage Data",
      isPresented: isPresented,
      actions: {
        Button("OK", action: {})
      },
      message: {
        Text("There is no image data. Please proceed from step 1 again")
      }
    )
  }
}
