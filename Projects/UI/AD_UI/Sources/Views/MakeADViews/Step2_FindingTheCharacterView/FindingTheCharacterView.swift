//
//  FindingTheCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct FindingTheCharacterView: ADUI {
  typealias MyFeature = FindingTheCharacterFeature
  let store: StoreOf<MyFeature>
  
  init(
    store: StoreOf<MyFeature> = rootViewStore.scope(
      state: \.findingTheCharacterState,
      action: RootViewFeature.Action.findingTheCharacterAction
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView(
        viewStore.binding(
          get: \.sharedState.isShowStepStatusBar,
          send: MyFeature.Action.bindIsShowStepStatusBar
        )
      ) {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList {
            VStack(alignment: .leading, spacing: 15) {
              CheckListButton1(state: viewStore.$checkState) {
                viewStore.send(.checkAction)
              }
              
              HStack {
                GIFView(gifName: "FindingTheCharacter_Preview1")
                GIFView(gifName: "FindingTheCharacter_Preview2")
              }
              .frame(height: 250)
            }
          }
          
          Spacer()
          
          ShowCropImageViewButton(state: viewStore.$checkState) {
            viewStore.send(.toggleCropImageView)
          }
        }
        .padding()
      }
      .fullScreenCover(
        isPresented: viewStore.$isShowCropImageView,
        onDismiss: {
          viewStore.send(.onDismissCropImageView)
        },
        content: {
          if let originalImage = viewStore.state.sharedState.originalImage,
             let boundingBoxDTO = viewStore.state.sharedState.boundingBoxDTO
          {
            CropImageView(
              originalImage: originalImage,
              boundingBoxDTO: boundingBoxDTO,
              cropAction: { cropResult in
                viewStore.send(.findTheCharacter(cropResult))
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
          }
        }
      )
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
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(description)
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  @MainActor
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description = "Resize the box to ensure it tightly fits one character."
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description, state: viewStore.$checkState) {
        viewStore.send(.checkAction)
      }
      
      HStack {
        GIFView(gifName: "FindingTheCharacter_Preview1")
        GIFView(gifName: "FindingTheCharacter_Preview2")
      }
      .frame(height: 250)
    }
  }
}


extension FindingTheCharacterView {
  @ViewBuilder
  func CheckListButton1(
    state: Binding<Bool>,
    action: @escaping () -> ()
  ) -> some View {
    let description = "Resize the box to ensure it tightly fits one character."
    
    CheckListButton(description, state: state, action: action)
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func ShowCropImageViewButton(
    state: Binding<Bool>,
    action: @escaping () -> ()
  ) -> some View {
    let viewFinder = "person.fill.viewfinder"
    let text = "Find the Character"
    
    ADButton(
      state.wrappedValue ? .active : .inActive,
      action: action
    ) {
      HStack {
        Image(systemName: viewFinder)
        Text(text)
      }
    }
  }
}

struct FindingTheCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    FindingTheCharacterView()
  }
}
