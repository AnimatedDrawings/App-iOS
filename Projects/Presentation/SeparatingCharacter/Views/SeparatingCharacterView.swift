//
//  SeparatingCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import MaskingImage
import ADUIKitSources
import ADUIKitResources
import SharedProvider
import SeparatingCharacterFeatures
import DomainModel

public struct SeparatingCharacterView: ADUI {
  public typealias MyFeature = SeparatingCharacterFeature
  
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
  
  @SharedValue(\.shared.makeAD.croppedImage) var croppedImage
  @SharedValue(\.shared.makeAD.initMaskImage) var initMaskImage
  @SharedValue(\.shared.makeAD.maskedImage) var maskedImage
  
  public var body: some View {
    ADScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        
        CheckList(myStep: .SeparatingCharacter) {
          CheckListContent(viewStore: viewStore)
        }
        
        ShowMaskingImageViewButton(viewStore.isActiveMaskingImageButton) {
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
          .alertNetworkError(isPresented: viewStore.$isShowNetworkErrorAlert)
        }
      }
    )
    .resetMakeADView(.SeparatingCharacter) {
      viewStore.send(.initState)
    }
  }
}

private extension SeparatingCharacterView {
  struct Title: View {
    let title = "SEPARATING CHARACTER"
    let description = "We’ve separated the character from the background, and highlighted it."
    
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

private extension SeparatingCharacterView {
  struct CheckListContent: View {
    let description1 = "If the body parts of your character are not highlighted, use the pen and eraser tools to fix it."
    let description2 = "If the arms or legs are stuck together, use the eraser tool to separate them"
    let myStep: Step = .SeparatingCharacter
    
    @ObservedObject var viewStore: MyViewStore
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description1,
          state: viewStore.checkState1
        ) {
          viewStore.send(.checkAction1)
        }
        
        GIFImage(sample: ADUIKitResourcesAsset.Gifs.step3Gif1)
          .frame(height: 250)
          .frame(maxWidth: .infinity, alignment: .center)
        
        CheckListButton(
          description: description2,
          state: viewStore.checkState2
        ) {
          viewStore.send(.checkAction2)
        }
        
        GIFImage(sample: ADUIKitResourcesAsset.Gifs.step3Gif2)
          .frame(height: 250, alignment: .center)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
  }
}

private extension SeparatingCharacterView {
  struct ShowMaskingImageViewButton: View {
    let handDraw = "hand.draw"
    let text = "Separate The Character"
    
    let state: Bool
    let action: () -> ()
    
    init(_ state: Bool, action: @escaping () -> Void) {
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


// MARK: - Preview

struct Preview_SeparatingCharacterView: View {
  @SharedValue(\.shared.stepBar.completeStep) var completeStep
  @SharedValue(\.shared.makeAD.croppedImage) var croppedImage
  @SharedValue(\.shared.makeAD.initMaskImage) var initMaskImage
  
  var body: some View {
    SeparatingCharacterView()
      .onAppear {
        completeStep = .FindingTheCharacter
        croppedImage = ADUIKitResourcesAsset.TestImages.croppedImage.image
        initMaskImage = ADUIKitResourcesAsset.TestImages.maskedImg.image
      }
  }
}

#Preview {
  Preview_SeparatingCharacterView()
}
