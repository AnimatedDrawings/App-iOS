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
  public let ui = OnBoardingView()
  public let store: StoreOf<OnBoardingStore>
  
  public init(
    store: StoreOf<OnBoardingStore> = Store(
      initialState: OnBoardingStore.State(),
      reducer: OnBoardingStore()
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

public struct OnBoardingStore: ReducerProtocol {
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case pushUploadADrawing
  }
  
  public init() {}
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .pushUploadADrawing:
        print("pushUploadADrawing")
        return .none
      }
    }
  }
}


struct OnBoarding_Previews: PreviewProvider {
  static var previews: some View {
    OnBoarding()
  }
}
