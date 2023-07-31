//
//  AddAnimationStore.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct AddAnimationStore: ReducerProtocol {
  public init() {}
  
  public typealias State = TCABaseState<AddAnimationStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
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
