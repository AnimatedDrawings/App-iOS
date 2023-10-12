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
import AD_UIKit
import SharedProvider
import SeparatingCharacter_Features
import Domain_Model

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
        
        ShowMaskingImageViewButton(state: viewStore.$isActiveMaskingImageButton) {
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

private extension SeparatingCharacterView {
  struct Title: View {
    let title = "SEPARATING CHARACTER"
    let description = "We’ve separated the character from the background, and highlighted it."
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADUIKitAsset.Color.blue2.swiftUIColor)
        
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
          state: viewStore.$checkState1,
          myStep: myStep
        ) {
          viewStore.send(.checkAction1)
        }
        
        GIFImage(sample: ADUIKitAsset.Gifs.step2Gif1)
          .frame(height: 250)
          .frame(maxWidth: .infinity, alignment: .center)
        
        CheckListButton(
          description: description2,
          state: viewStore.$checkState2,
          myStep: myStep
        ) {
          viewStore.send(.checkAction2)
        }
        
        GIFImage(sample: ADUIKitAsset.Gifs.step3Gif2)
          .frame(height: 250, alignment: .center)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
  }
}

private extension SeparatingCharacterView {
  struct ShowMaskingImageViewButton: View {
    let viewFinder = "hand.draw"
    let text = "Separate The Character"
    
    @Binding var state: Bool
    let action: () -> ()
    
    let myStep: Step = .SeparatingCharacter
    @Dependency(\.shared.stepBar.completeStep) var completeStep
    
    var body: some View {
      ADButton(
        state: state,
        action: action
      ) {
        HStack {
          Image(systemName: viewFinder)
          Text(text)
        }
      }
      .task {
        for await tmpStep in await completeStep.values() {
          state = state && (myStep.rawValue <= tmpStep.rawValue)
        }
      }
    }
  }
}

struct Previews_SeparatingCharacterView: View {
  @SharedValue(\.shared.stepBar.completeStep) var completeStep
  
  var body: some View {
    SeparatingCharacterView()
      .onAppear {
        completeStep = .FindingTheCharacter
      }
  }
}

// MARK: - Previews
struct SeparatingCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_SeparatingCharacterView()
  }
}
