//
//  OnBoarding.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import AD_UI
import AD_Utils

struct OnBoarding: ADFeature {
  typealias MyUI = OnBoardingView
  typealias MyReducer = OnBoardingStore
  
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
        startButtonAction: { viewStore.send(.pushUploadADrawing) }
      )
      .navigationDestination(
        isPresented: viewStore.binding(\.$isPushUploadADrawing),
        destination: { UploadADrawing() }
      )
    }
  }
}

struct OnBoarding_Previews: PreviewProvider {
  static var previews: some View {
    OnBoarding()
  }
}
