//
//  FindingTheCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import ADUIKitSources
import ADUIKitResources
import FindingTheCharacterFeatures
import CropImage
import DomainModel
import SharedProvider

public struct FindingTheCharacterView: ADUI {
  public typealias MyFeature = FindingTheCharacterFeature
  
  public init(
    store: MyStore = Store(initialState: .init()) {
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
  
  @SharedValue(\.shared.makeAD.originalImage) var originalImage
  @SharedValue(\.shared.makeAD.boundingBox) var boundingBox
  
  public var body: some View {
    ADScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        
        CheckList(myStep: .FindingTheCharacter) {
          CheckListContent(viewStore: viewStore)
        }
        
        Spacer()
        
        ShowCropImageViewButton(viewStore.checkState) {
          viewStore.send(.toggleCropImageView)
        }
        
        Spacer().frame(height: 1)
      }
      .padding()
    }
    .fullScreenCover(
      isPresented: viewStore.$isShowCropImageView,
      onDismiss: {
        viewStore.send(.onDismissCropImageView)
      },
      content: {
        CropImageView(
          cropNextAction: { croppedUIImage, croppedCGRect in
            viewStore.send(.findTheCharacter(croppedUIImage, croppedCGRect))
          },
          store: self.store.scope(
            state: \.cropImage,
            action: FindingTheCharacterFeature.Action.cropImage
          )
        )
        .transparentBlurBackground()
        .addLoadingView(
          isShow: viewStore.state.isShowLoadingView,
          description: "Cropping Image ..."
        )
        .alertNetworkError(isPresented: viewStore.$isShowNetworkErrorAlert)
      }
    )
    .resetMakeADView(.FindingTheCharacter) {
      viewStore.send(.initState)
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
    @ObservedObject var viewStore: MyViewStore
    let description = "Resize the box to ensure it tightly fits one character."
    let myStep: Step = .FindingTheCharacter
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description,
          state: viewStore.checkState
        ) {
          viewStore.send(.checkAction)
        }
        
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

// MARK: - Previews

struct Preview_FindingTheCharacter: View {
  @SharedValue(\.shared.stepBar.completeStep) var completeStep
  @SharedValue(\.shared.makeAD.originalImage) var originalImage
  @SharedValue(\.shared.makeAD.boundingBox) var boundingBox
  
  let store: StoreOf<FindingTheCharacterFeature>
  
  init(
    store: StoreOf<FindingTheCharacterFeature> = Store(
      initialState: FindingTheCharacterFeature.State(checkState: true)
    ) {
      FindingTheCharacterFeature()
    }
  ) {
    self.store = store
    self.completeStep = .UploadADrawing
    self.originalImage = ADUIKitResourcesAsset.SampleDrawing.garlic.image
    self.boundingBox = CGRect(x: 100, y: 100, width: 500, height: 800)
  }
  
  var body: some View {
    FindingTheCharacterView(store: store)
  }
}

#Preview {
  Preview_FindingTheCharacter()
}
