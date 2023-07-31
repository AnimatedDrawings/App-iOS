//
//  RootViewStore.swift
//  AD_Feature
//
//  Created by minii on 2023/07/31.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct RootViewStore: ReducerProtocol {
  public init() {}
  
  public typealias State = TCABaseState<RootViewStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var isTapStartButton = false
    @BindingState public var isCompleteMakeAD = false
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      }
    }
  }
}
