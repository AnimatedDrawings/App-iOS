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
  
  let originalImage: UIImage = ADUtilsAsset.SampleDrawing.garlic.image
  
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
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          CheckList(with: viewStore)
          
          Preview()
          
          CropImageView(originalImage: originalImage)
            .scrollDisabled(true)
          
          Spacer()
        }
        .padding()
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
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(description)
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func CheckList(with viewStore: MyViewStore) -> some View {
    let title = "C H E C K L I S T"
    let description = "Resize the box to ensure it tightly fits one character."
    
    VStack(alignment: .leading, spacing: 15) {
      Text(title)
        .font(.system(.title3, weight: .medium))
      
      CheckListButton(description, state: viewStore.binding(\.$checkState)) {
        viewStore.send(.checkAction)
      }
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func Preview() -> some View {
    HStack {
      GIFView(gifName: "FindingTheCharacter_Preview1")
      GIFView(gifName: "FindingTheCharacter_Preview2")
    }
    .frame(height: 250)
  }
}

struct FindingTheCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    FindingTheCharacterView()
  }
}
