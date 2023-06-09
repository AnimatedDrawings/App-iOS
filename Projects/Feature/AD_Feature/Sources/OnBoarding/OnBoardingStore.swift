//
//  OnBoardingStore.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct OnBoardingStore: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
    
    @BindingState var isPushUploadADrawing = false
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case pushUploadADrawing
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .pushUploadADrawing:
        state.isPushUploadADrawing.toggle()
        return .none
      }
    }
  }
}
