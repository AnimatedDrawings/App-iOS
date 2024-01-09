//
//  CropImageFeature.swift
//  CropImageFeatures
//
//  Created by chminii on 1/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib

public struct CropImageFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    MainReducer()
  }
}

public extension CropImageFeature {
  struct State: Equatable {
    public init() {}
  }
}

public extension CropImageFeature {
  enum Action: Equatable {
    case saveAction
    case cancelAction
  }
}

extension CropImageFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .saveAction:
        return .none
      case .cancelAction:
        return .none
      }
    }
  }
}
