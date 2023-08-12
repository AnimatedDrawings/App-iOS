//
//  TCABaseState.swift
//  AD_Feature
//
//  Created by minii on 2023/06/15.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

@dynamicMemberLookup
public struct TCABaseState<State: Equatable>: Equatable {
  public var sharedState: SharedState
  public var state: State
  
  public init(sharedState:  SharedState, state: State) {
    self.sharedState = sharedState
    self.state = state
  }
  
  public subscript<T>(dynamicMember keyPath: WritableKeyPath<State, T>) -> T {
    get { state[keyPath: keyPath] }
    set { state[keyPath: keyPath] = newValue }
  }
}
