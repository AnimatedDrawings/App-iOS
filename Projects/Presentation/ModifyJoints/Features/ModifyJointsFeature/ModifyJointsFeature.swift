//
//  ModifyJointsFeature.swift
//  ModifyJointsExample
//
//  Created by chminii on 1/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import Foundation

@Reducer
public struct ModifyJointsFeature {
  public init() {}
  
  public var body: some ReducerOf<Self> {
    MainReducer()
    ViewReducer()
    DelegateReducer()
  }
}

public extension ModifyJointsFeature {
  enum Action: Equatable, ViewAction, DelegateAction {
    case view(ViewActions)
    case delegate(DelegateActions)
  }
}

extension ModifyJointsFeature {
  func MainReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
  }
}
