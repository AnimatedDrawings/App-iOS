//
//  RootView.swift
//  AD_UI
//
//  Created by minii on 2023/06/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import OnBoarding
import MakeAD
import ConfigureAnimation
import ThirdPartyLib
import SharedProvider

public struct RootView: ADUI {
  public typealias MyFeature = RootViewFeature
  public let store: StoreOf<MyFeature>
  
  public init(
    store: StoreOf<MyFeature> = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.store = store
  }
  
  @SharedValue(\.shared.makeAD.isShowConfigureAnimationView) var isShowConfigureAnimationView
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      if !(viewStore.isTapStartButton) {
        OnBoardingView(isTapStartButton: viewStore.$isTapStartButton)
      } else {
        if !(isShowConfigureAnimationView) {
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
