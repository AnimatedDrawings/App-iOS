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

public struct OnBoarding: ADFeature {
  public typealias MyUI = OnBoardingView
  public typealias MyReducer = OnBoardingStore
  
  public let ui = MyUI()
  public let store: StoreOf<MyReducer>
  
  public init(
    store: StoreOf<MyReducer> = Store(
      initialState: MyReducer.State(),
      reducer: MyReducer()
    )
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ui.main(startButtonAction: { viewStore.send(.pushUploadADrawing) })
    }
  }
}

struct OnBoarding_Previews: PreviewProvider {
  static var previews: some View {
    OnBoarding()
  }
}
