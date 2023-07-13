//
//  FindingCharacterJointsStore.swift
//  AD_Feature
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct FindingCharacterJointsStore: ReducerProtocol {
  public init() {}
  
  public typealias State = TCABaseState<FindingCharacterJointsStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
  }
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
