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

public let rootViewStore = Store(initialState: RootViewFeature.State()) {
  RootViewFeature()
}

public struct RootView: View {
  public typealias MyFeature = RootViewFeature
  public let store: StoreOf<MyFeature>
  
  public init(store: StoreOf<MyFeature> = rootViewStore) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      if !(viewStore.isTapStartButton) {
        OnBoardingView(isTapStartButton: viewStore.$isTapStartButton)
      } else {
        if !(viewStore.sharedState.isShowAddAnimationView) {
          MakeADView()
        } else {
          ConfigureAnimationView()
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
