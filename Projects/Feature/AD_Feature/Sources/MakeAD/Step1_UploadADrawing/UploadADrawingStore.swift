//
//  UploadADrawingStore.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

struct UploadADrawingStore: ReducerProtocol {
  struct State: Equatable {
  }
  
  enum Action: Equatable {
    case uploadAction
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .uploadAction:
        print("uploadAction")
        return .none
      }
    }
  }
}
