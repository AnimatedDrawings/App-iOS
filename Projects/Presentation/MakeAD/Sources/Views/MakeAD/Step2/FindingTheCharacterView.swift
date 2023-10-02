//
//  FindingTheCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import MakeAD_Feature
import AD_UIKit
import CropImage
import Domain_Model
import SharedProvider

struct FindingTheCharacterView: ADUI {
  typealias MyFeature = FindingTheCharacterFeature
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
  
  @SharedValue(\.shared.makeAD.originalImage) var originalImage
  @SharedValue(\.shared.makeAD.boundingBoxDTO) var boundingBoxDTO
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList(myStep: .FindingTheCharacter) {
            CheckListContent(with: viewStore)
          }
          
          Spacer()
          
          ShowCropImageViewButton(state: viewStore.checkState) {
            viewStore.send(.toggleCropImageView)
          }
          
          Spacer().frame(height: 20)
        }
        .padding()
        .fullScreenCover(
          isPresented: viewStore.$isShowCropImageView,
          onDismiss: {
            viewStore.send(.onDismissCropImageView)
          },
          content: {
            if let originalImage = originalImage,
               let boundingBoxDTO = boundingBoxDTO {
              CropImageView(
                originalImage: originalImage,
                originCGRect: boundingBoxDTO.toCGRect(),
                cropNextAction: { croppedUIImage, croppedCGRect in
                  viewStore.send(.findTheCharacter(croppedUIImage, croppedCGRect))
                },
                cancelAction: {
                  viewStore.send(.toggleCropImageView)
                }
              )
              .transparentBlurBackground()
              .addLoadingView(
                isShow: viewStore.state.isShowLoadingView,
                description: "Cropping Image ..."
              )
              .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
            }
          }
        )
      }
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func Title() -> some View {
    let title = "FINDING THE CHARACTER"
    let description = "We’ve identified the character, and put a box around it."
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.title, weight: .semibold))
        .foregroundColor(ADUIKitAsset.Color.blue2.swiftUIColor)
      
      Text(description)
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description = "Resize the box to ensure it tightly fits one character."
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description, state: viewStore.checkState) {
        viewStore.send(.checkAction)
      }
      
      HStack {
        GIFImage(sample: ADUIKitAsset.Gifs.step2Gif1)
        GIFImage(sample: ADUIKitAsset.Gifs.step2Gif2)
      }
      .frame(height: 250)
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func ShowCropImageViewButton(
    state: Bool,
    action: @escaping () -> ()
  ) -> some View {
    let viewFinder = "person.fill.viewfinder"
    let text = "Find the Character"
    
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

struct FindingTheCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    FindingTheCharacterView()
  }
}
