//
//  FindingTheCharacter.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import AD_UI
import AD_Utils

struct FindingTheCharacter: ADFeature {
  typealias MyUI = FindingTheCharacterView
  typealias MyReducer = FindingTheCharacterStore
  
  let ui = MyUI()
  let store: StoreOf<MyReducer>
  
  let originalImage: UIImage
  
  init(
    store: StoreOf<MyReducer> = Store(
      initialState: MyReducer.State(),
      reducer: MyReducer()
    ),
    originalImage: UIImage
  ) {
    self.store = store
    self.originalImage = originalImage
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ui.Main(
        originalImage: originalImage,
        checkState: viewStore.binding(\.$checkState),
        checkAction: { viewStore.send(.checkAction) }
      )
    }
  }
}
