//
//  MakeADFeature.swift
//  MakeADFeatures
//
//  Created by chminii on 2/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UploadADrawingFeatures

@Reducer
public struct MakeADFeature {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.uploadADrawing, action: \.scope.uploadADrawing) {
      UploadADrawingFeature()
    }
    
    BindingReducer()
    MainReducer()
    ScopeReducer()
  }
}

public extension MakeADFeature {
  @CasePathable
  enum Action: Equatable, BindableAction, ScopeAction {
    case binding(BindingAction<State>)
    case scope(ScopeActions)
  }
  
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      default:
        return .none
      }
    }
  }
}
