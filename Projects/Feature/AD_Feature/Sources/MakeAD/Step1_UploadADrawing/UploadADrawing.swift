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
        checkState1: viewStore.binding(\.$checkState1),
        checkAction1: { viewStore.send(.checkAction1) },
        checkState2: viewStore.binding(\.$checkState2),
        checkAction2: { viewStore.send(.checkAction2) },
        checkState3: viewStore.binding(\.$checkState3),
        checkAction3: { viewStore.send(.checkAction3) },
        
        uploadState: viewStore.binding(\.$uploadState),
        uploadAction: { viewStore.send(.uploadAction) },
        
        sampleTapAction: { viewStore.send(.sampleTapAction) }
      )
      .navigationDestination(isPresented: viewStore.binding(\.$isPushFindingCharacter)) {
        FindingTheCharacter(originalImage: viewStore.originalImage)
      }
    }
  }
}

struct UploadADrawing_Previews: PreviewProvider {
  static var previews: some View {
    UploadADrawing()
  }
}
