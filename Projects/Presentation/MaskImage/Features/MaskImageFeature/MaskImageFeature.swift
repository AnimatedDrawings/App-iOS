//
//  MaskImageFeature.swift
//  MaskImage
//
//  Created by chminii on 1/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture

@Reducer
public struct MaskImageFeature {
  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    MainReducer()
    ViewReducer()
    DelegateReducer()
  }
}

public extension MaskImageFeature {
  enum Action: Equatable, BindableAction, ViewAction, DelegateAction {
    case binding(BindingAction<State>)
    case view(ViewActions)
    case delegate(DelegateActions)
  }
}

public extension MaskImageFeature {
  func MainReducer() -> some ReducerOf<Self> {
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
