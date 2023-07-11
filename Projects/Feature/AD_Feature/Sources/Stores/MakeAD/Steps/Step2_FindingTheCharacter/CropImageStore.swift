//
//  CropImageStore.swift
//  AD_Feature
//
//  Created by minii on 2023/07/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct CropImageStore: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
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
