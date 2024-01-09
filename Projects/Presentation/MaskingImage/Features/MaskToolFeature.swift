//
//  MaskToolFeature.swift
//  MaskingImage
//
//  Created by chminii on 1/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib

public struct MaskToolFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    MainReducer()
  }
}

public extension MaskToolFeature {
  struct State: Equatable {
    public init() {}
  }
}

public extension MaskToolFeature {
  enum Action: Equatable {
    case draw
    case erase
    case undo
    case reset
  }
}

extension MaskToolFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
