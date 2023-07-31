//
//  RootView.swift
//  AD_UI
//
//  Created by minii on 2023/06/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

public struct RootView: View {
  public typealias MyStore = RootViewStore
  public let store: StoreOf<MyStore>
  
  public init(
    store: StoreOf<MyStore> = Store(
      initialState: MyStore.State(
        sharedState: SharedState(),
        state: RootViewStore.MyState()
      ),
      reducer: MyStore()
    )
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      if !(viewStore.isTapStartButton) {
        OnBoardingView(isTapStartButton: viewStore.binding(\.$isTapStartButton))
      } else {
        if !(viewStore.isCompleteMakeAD) {
          MakeADView()
        } else {
          AddAnimationView()
        }
      }
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
