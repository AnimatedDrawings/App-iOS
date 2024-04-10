//
//  SeparateCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import SeparateCharacterFeatures
import ADComposableArchitecture
import MaskImage
import ADUIKit
import ADResources
import DomainModels

public struct SeparateCharacterView: View {
  @Perception.Bindable var store: StoreOf<SeparateCharacterFeature>
  
  public var body: some View {
    ADScrollView($store.step.isShowStepBar.sending(\.update.setIsShowStepBar)) {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        
        CheckList(
          myStep: MakeADStep.SeparatingCharacter.rawValue,
          completeStep: MakeADStep.SeparatingCharacter.rawValue
        ) {
          CheckListContent(
            checkState1: $store.check.list1,
            checkState2: $store.check.list2
          )
        }
        
        MaskImageButton(state: store.maskImageButton) {
          store.send(.view(.pushMaskImageView))
        }
        
        Spacer().frame(height: 20)
      }
      .padding()
    }
    .alertNoMaskImageError(isPresented: $store.alert.noMaskImage)
    .fullScreenCover(
      isPresented: $store.maskImageView,
      content: { IfLetMaskImageView() }
    )
    .task { await store.send(.view(.task)).finish() }
  }
}

private extension SeparateCharacterView {
  @MainActor
  func IfLetMaskImageView() -> some View {
    Group {
      if let maskImageStore = self.store.scope(state: \.maskImage, action: \.scope.maskImage) {
        WithPerceptionTracking {
          MaskImageView(store: maskImageStore)
            .transparentBlurBackground()
            .addLoadingView(
              isShow: store.loadingView,
              description: "Masking Image..."
            )
            .alertNetworkError(isPresented: $store.alert.networkError)
        }
      } else {
        Text("No MaskImage...")
      }
    }
  }
}

private extension SeparateCharacterView {
  struct Title: View {
    let title = "SEPARATING CHARACTER"
    let description = "We’ve separated the character from the background, and highlighted it."
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADResourcesAsset.Color.blue2.swiftUIColor)
        
        Text(description)
      }
    }
  }
}

private extension SeparateCharacterView {
  struct CheckListContent: View {
    @Binding var checkState1: Bool
    @Binding var checkState2: Bool
    
    let description1 = "If the body parts of your character are not highlighted, use the pen and eraser tools to fix it."
    let description2 = "If the arms or legs are stuck together, use the eraser tool to separate them"
    let myStep: MakeADStep = .SeparatingCharacter
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description1,
          state: $checkState1
        )
        
        GIFImage(sample: ADResourcesAsset.Gifs.step3Gif1)
          .frame(height: 250)
          .frame(maxWidth: .infinity, alignment: .center)
        
        CheckListButton(
          description: description2,
          state: $checkState2
        )
        
        GIFImage(sample: ADResourcesAsset.Gifs.step3Gif2)
          .frame(height: 250, alignment: .center)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
  }
}

private extension SeparateCharacterView {
  struct MaskImageButton: View {
    let handDraw = "hand.draw"
    let text = "Separate The Character"
    
    let state: Bool
    let action: () -> ()
    
    init(state: Bool, action: @escaping () -> Void) {
      self.state = state
      self.action = action
    }
    
    var body: some View {
      ADButton(
        state: state,
        action: action,
        content: {
          HStack {
            Image(systemName: handDraw)
            Text(text)
          }
        }
      )
    }
  }
}

private extension View {
  func alertNoMaskImageError(
    isPresented: Binding<Bool>
  ) -> some View {
    self.alert(
      "No MaskImage Data",
      isPresented: isPresented,
      actions: {
        Button("OK", action: {})
      },
      message: {
        Text("There is no mask image data. Please proceed from step 2 again")
      }
    )
  }
}
