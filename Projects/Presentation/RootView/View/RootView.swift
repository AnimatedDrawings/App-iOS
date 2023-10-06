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
import RootView_Feature

public struct RootView: ADUI {
  public typealias MyFeature = RootViewFeature
  @StateObject var viewStore: MyViewStore
  
  public init(
    viewStore: MyViewStore = .init(
      Store(initialState: .init(), reducer: {
        MyFeature()
      }),
      observe: { $0 }
    )
  ) {
    self._viewStore = StateObject(wrappedValue: viewStore)
  }
  
  @SharedValue(\.shared.makeAD.isShowConfigureAnimationView) var isShowConfigureAnimationView
  
  public var body: some View {
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

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
