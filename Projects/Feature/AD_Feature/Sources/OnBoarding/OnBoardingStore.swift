//
//  OnBoardingStore.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct OnBoardingStore: ReducerProtocol {
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case pushUploadADrawing
  }
  
  public init() {}
  
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .pushUploadADrawing:
        print("pushUploadADrawing")
        return .none
      }
    }
  }
}
