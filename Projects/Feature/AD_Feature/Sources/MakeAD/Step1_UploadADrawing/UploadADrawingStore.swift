//
//  UploadADrawingStore.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

struct UploadADrawingStore: ReducerProtocol {
  struct State: Equatable {
    @BindingState var checkState1 = false
    @BindingState var checkState2 = false
    @BindingState var checkState3 = false
    @BindingState var uploadState = false
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkAction1
    case checkAction2
    case checkAction3
    case uploadAction
    case sampleTapAction
  }
  
  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkAction1:
        state.checkState1.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .checkAction2:
        state.checkState2.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .checkAction3:
        state.checkState3.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .uploadAction:
        print("uploadAction")
        return .none
        
      case .sampleTapAction:
        print("sampleTapAction")
        return .none
      }
    }
  }
  
  func activeUploadButton(state: inout UploadADrawingStore.State) {
    if state.checkState1 && state.checkState2 && state.checkState3 {
      state.uploadState = true
    } else {
      state.uploadState = false
    }
  }
}
