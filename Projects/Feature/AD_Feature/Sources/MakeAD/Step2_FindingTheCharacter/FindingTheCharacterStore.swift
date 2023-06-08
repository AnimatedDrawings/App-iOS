//
//  FindingTheCharacterStore.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

struct FindingTheCharacterStore: ReducerProtocol {
  struct State: Equatable {
    @BindingState var checkState = false
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkAction
  }
  
  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkAction:
        state.checkState.toggle()
        return .none
      }
    }
  }
}
