//
//  RootViewFeature.swift
//  AD_UI
//
//  Created by minii on 2023/09/14.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib

public struct RootViewFeature: Reducer {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
    
    @BindingState public var isTapStartButton = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      }
    }
  }
}
