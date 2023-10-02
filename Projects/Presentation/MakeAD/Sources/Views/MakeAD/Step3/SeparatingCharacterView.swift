//
//  SeparatingCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import MakeAD_Feature
import MaskingImage
import AD_UIKit
import SharedProvider

struct SeparatingCharacterView: ADUI {
  typealias MyFeature = SeparatingCharacterFeature
  let store: StoreOf<MyFeature>
  
  init(
    store: StoreOf<MyFeature> = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.store = store
  }
  
  @SharedValue(\.shared.makeAD.croppedImage) var croppedImage
  @SharedValue(\.shared.makeAD.initMaskImage) var initMaskImage
  @SharedValue(\.shared.makeAD.maskedImage) var maskedImage
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList(myStep: .SeparatingCharacter) {
            CheckListContent(with: viewStore)
          }
          
          ShowMaskingImageViewButton(state: viewStore.isActiveMaskingImageButton) {
            viewStore.send(.toggleMaskingImageView)
          }
          
          Spacer().frame(height: 20)
        }
        .padding()
      }
      .fullScreenCover(
        isPresented: viewStore.$isShowMaskingImageView,
        onDismiss: {
          viewStore.send(.onDismissMakingImageView)
        },
        content: {
          if let croppedImage = croppedImage,
             let initMaskImage = initMaskImage
          {
            MaskingImageView(
              croppedImage: croppedImage,
              initMaskImage: initMaskImage,
              maskedImage: $maskedImage,
              maskNextAction: { maskResult in
                viewStore.send(.maskNextAction(maskResult))
              },
              cancelAction: {
                viewStore.send(.toggleMaskingImageView)
              }
            )
            .transparentBlurBackground()
            .addLoadingView(
              isShow: viewStore.state.isShowLoadingView,
              description: "Separating Character..."
            )
            .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
          }
        }
      )
    }
  }
}

extension SeparatingCharacterView {
  @ViewBuilder
  func Title() -> some View {
    let title = "SEPARATING CHARACTER"
    let description = "We’ve separated the character from the background, and highlighted it."
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.title, weight: .semibold))
        .foregroundColor(ADUIKitAsset.Color.blue2.swiftUIColor)
      
      Text(description)
    }
  }
}

extension SeparatingCharacterView {
  @ViewBuilder
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    VStack(alignment: .leading, spacing: 15) {
      let description1 = "If the body parts of your character are not highlighted, use the pen and eraser tools to fix it."
      let description2 = "If the arms or legs are stuck together, use the eraser tool to separate them"
      
      CheckListButton(description1, state: viewStore.checkState1) {
        viewStore.send(.checkAction1)
      }
      
      GIFImage(sample: ADUIKitAsset.Gifs.step2Gif1)
        .frame(height: 250)
        .frame(maxWidth: .infinity, alignment: .center)
      
      CheckListButton(description2, state: viewStore.checkState2) {
        viewStore.send(.checkAction2)
      }
      
      GIFImage(sample: ADUIKitAsset.Gifs.step3Gif2)
        .frame(height: 250, alignment: .center)
        .frame(maxWidth: .infinity, alignment: .center)
    }
  }
}

extension SeparatingCharacterView {
  @ViewBuilder
  func ShowMaskingImageViewButton(
    state: Bool,
    action: @escaping () -> ()
  ) -> some View {
    let viewFinder = "hand.draw"
    let text = "Separate The Character"
    
    ADButton(
      state ? .active : .inActive,
      action: action
    ) {
      HStack {
        Image(systemName: viewFinder)
        Text(text)
      }
    }
  }
}

// MARK: - Previews
struct SeparatingCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    SeparatingCharacterView()
  }
}
