//
//  FindingTheCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import FindingTheCharacter_Feature
import AD_UIKit
import CropImage
import Domain_Model
import SharedProvider

public struct FindingTheCharacterView: ADUI {
  public typealias MyFeature = FindingTheCharacterFeature
  public let store: StoreOf<MyFeature>
  
  public init(
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
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList(myStep: .FindingTheCharacter) {
            CheckListContent(viewStore: viewStore)
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

private extension FindingTheCharacterView {
  struct Title: View {
    let title = "FINDING THE CHARACTER"
    let description = "We’ve identified the character, and put a box around it."
    
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

private extension FindingTheCharacterView {
  struct CheckListContent: View {
    let description = "Resize the box to ensure it tightly fits one character."
    
    let viewStore: MyViewStore
    
    var body: some View {
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
}

private extension FindingTheCharacterView {
  struct ShowCropImageViewButton: View {
    let viewFinder = "person.fill.viewfinder"
    let text = "Find the Character"
    
    let state: Bool
    let action: () -> ()
    
    var body: some View {
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
}

// MARK: - Previews

struct FindingTheCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    FindingTheCharacterView()
  }
}
