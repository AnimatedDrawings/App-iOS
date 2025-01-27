//
//  FindTheCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import FindTheCharacterFeatures
import ADUIKit
import ADResources
import DomainModels
import CropImage

public struct FindTheCharacterView: View {
  @Bindable var store: StoreOf<FindTheCharacterFeature>
  
  public init(
    store: StoreOf<FindTheCharacterFeature> = Store(
      initialState: .init()
    ) {
      FindTheCharacterFeature()
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
            myStep: MakeADStep.FindTheCharacter.rawValue,
            completeStep: store.step.completeStep.rawValue
          ) {
            CheckListContent(state: $store.checkList)
          }
          
          Spacer()
          
          ShowCropImageViewButton(store.checkList) {
            store.send(.view(.pushCropImageView))
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
    }
    .task { await store.send(.view(.task)).finish() }
  }
}

private extension FindTheCharacterView {
  @MainActor
  func IfLetCropImageView() -> some View {
    Group {
      if let cropImageStore = self.store.scope(state: \.cropImage, action: \.scope.cropImage) {
        WithPerceptionTracking {
          CropImageView(store: cropImageStore)
            .transparentBlurBackground()
            .addLoadingView(
              isShow: store.loadingView,
              description: "Crop Image..."
            )
            .alertNetworkError(isPresented: $store.alert.networkError)
        }
      } else {
        Text("No CropImage...")
      }
    }
  }
}

private extension FindTheCharacterView {
  struct Title: View {
    let title = "FINDING THE CHARACTER"
    let description = "We’ve identified the character, and put a box around it."
    let color = ADResourcesAsset.Color.blue2.swiftUIColor
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(color)
        
        Text(description)
      }
    }
  }
}

private extension FindTheCharacterView {
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
          GIFImage(sample: ADResourcesAsset.Gifs.step2Gif1)
          GIFImage(sample: ADResourcesAsset.Gifs.step2Gif2)
        }
        .frame(height: 250)
      }
    }
  }
}

private extension FindTheCharacterView {
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
        Text("There is no crop image data. Please proceed from step 1 again")
      }
    )
  }
}
