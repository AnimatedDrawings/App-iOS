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
  typealias MyStore = FindingTheCharacterStore
  let store: StoreOf<MyStore>
  
  init(
    store: StoreOf<MyStore> = Store(
      initialState: MyStore.State(sharedState: SharedState(), state: FindingTheCharacterStore.MyState()),
      reducer: MyStore()
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList {
            CheckListContent(with: viewStore)
          }
          
          Spacer()
          
          ShowCropImageViewButton(state: viewStore.binding(\.$checkState)) {
            viewStore.send(.toggleCropImageView)
          }
        }
        .padding()
      }
      .fullScreenCover(
        isPresented: viewStore.binding(\.$isShowCropImageView),
        onDismiss: {
          
        },
        content: {
          if let originalImage = viewStore.state.sharedState.originalImage {
            CropImageView(
              originalImage: originalImage,
              croppedImage: viewStore.binding(\.sharedState.$croppedImage),
              isShowCropImageView: viewStore.binding(\.$isShowCropImageView),
              saveNextAction: {
                viewStore.send(.toggleCropImageView)
              })
            .transparentBlurBackground()
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
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description = "Resize the box to ensure it tightly fits one character."
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description, state: viewStore.binding(\.$checkState)) {
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
      .environmentObject(StepStatusBarEnvironment())
  }
}
