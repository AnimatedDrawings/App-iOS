//
//  SeparateCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ADResources
import ADUIKit
import DomainModels
import MaskImage
import SeparateCharacterFeatures
import SwiftUI

public struct SeparateCharacterView: View {
  @Bindable var store: StoreOf<SeparateCharacterFeature>

  public init(
    store: StoreOf<SeparateCharacterFeature> = Store(
      initialState: .init()
    ) {
      SeparateCharacterFeature()
    }
  ) {
    self.store = store
  }

  public var body: some View {
    ADScrollView($store.step.isShowStepBar.sending(\.update.setIsShowStepBar)) {
      VStack(alignment: .leading, spacing: 20) {
        Title()

        CheckList(
          myStep: MakeADStep.SeparateCharacter.rawValue,
          completeStep: store.step.completeStep.rawValue
        ) {
          CheckListContent(store: store)
        }

        MaskImageButton(state: store.maskImageButton) {
          store.send(.view(.pushMaskImageView))
        }

        Spacer().frame(height: 20)
      }
      .padding()
    }
    .task { await store.send(.view(.task)).finish() }
    .alertNoMaskImageError(isPresented: $store.alert.noMaskImage)
    
    .fullScreenCover(
      isPresented: $store.maskImageView,
      content: { IfLetMaskImageView() }
    )
  }
}

extension SeparateCharacterView {
  @MainActor
  fileprivate func IfLetMaskImageView() -> some View {
    Group {
      if let maskImageStore = self.store.scope(
        state: \.maskImage,
        action: \.scope.maskImage
      ) {
        MaskImageView(store: maskImageStore)
          .transparentBlurBackground()
          .addLoadingView(
            isShow: store.loadingView,
            description: "Mask Image..."
          )
          .alertNetworkError(isPresented: $store.alert.networkError)
          .alertWorkLoadHighError(isPresented: $store.alert.workLoadHighError)
      } else {
        Text("No MaskImage...")
      }
    }
  }
}

extension SeparateCharacterView {
  fileprivate struct Title: View {
    let title = "SEPARATING CHARACTER"
    let description = "We've separated the character from the background, and highlighted it."

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

extension SeparateCharacterView {
  fileprivate struct CheckListContent: View {
    @Bindable var store: StoreOf<SeparateCharacterFeature>

    let description1 =
      "If the body parts of your character are not highlighted, use the pen and eraser tools to fix it."
    let description2 =
      "If the arms or legs are stuck together, use the eraser tool to separate them"
    let myStep: MakeADStep = .SeparateCharacter

    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description1,
          state: $store.check.list1.sending(\.view.check.list1)
        )

        GIFImage(sample: ADResourcesAsset.Gifs.step3Gif1)
          .frame(height: 250)
          .frame(maxWidth: .infinity, alignment: .center)

        CheckListButton(
          description: description2,
          state: $store.check.list2.sending(\.view.check.list2)
        )

        GIFImage(sample: ADResourcesAsset.Gifs.step3Gif2)
          .frame(height: 250, alignment: .center)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
  }
}

extension SeparateCharacterView {
  fileprivate struct MaskImageButton: View {
    let handDraw = "hand.draw"
    let text = "Separate The Character"

    let state: Bool
    let action: () -> Void

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

extension View {
  fileprivate func alertNoMaskImageError(
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
