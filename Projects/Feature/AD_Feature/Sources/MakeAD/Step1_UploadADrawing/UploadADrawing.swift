//
//  UploadADrawing.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_UI
import AD_Utils
import ComposableArchitecture

struct UploadADrawing: ADFeature {
  typealias MyUI = UploadADrawingView
  typealias MyReducer = UploadADrawingStore
  
  let ui = MyUI()
  let store: StoreOf<MyReducer>
  
  init(
    store: StoreOf<MyReducer> = Store(
      initialState: MyReducer.State(),
      reducer: MyReducer()
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ui.Main(
        uploadAction: { viewStore.send(.uploadAction) },
        sampleTapAction: { viewStore.send(.sampleTapAction) }
      )
    }
  }
}

struct UploadADrawing_Previews: PreviewProvider {
  static var previews: some View {
    UploadADrawing()
  }
}
