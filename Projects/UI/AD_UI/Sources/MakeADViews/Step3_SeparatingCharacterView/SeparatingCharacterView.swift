//
//  SeparatingCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/07/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct SeparatingCharacterView: ADUI {
  typealias MyStore = SeparatingCharacterStore
  let store: StoreOf<MyStore>
  
  init(
    store: StoreOf<MyStore> = Store(
      initialState: MyStore.State(),
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
          
        }
        .padding()
      }
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
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(description)
    }
  }
}

extension SeparatingCharacterView {
  @ViewBuilder
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description1 = "If the body parts of your character are not highlighted, use the pen and eraser tools to fix it."
    let description2 = "If the arms or legs are stuck together, use the eraser tool to separate them"
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description1, state: viewStore.binding(\.$checkState1)) {
        viewStore.send(.checkAction1)
      }
      
      GIFView(gifName: "SeparatingCharacter_Preview1")
        .frame(height: 250)
      
      CheckListButton(description2, state: viewStore.binding(\.$checkState2)) {
        viewStore.send(.checkAction2)
      }
      
      GIFView(gifName: "SeparatingCharacter_Preview2")
        .frame(height: 250)
    }
  }
}

struct PreviewsSeparatingCharacterView: View {
  var body: some View {
    SeparatingCharacterView()
      .environmentObject(StepStatusBarEnvironment())
  }
}

struct SeparatingCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsSeparatingCharacterView()
  }
}
