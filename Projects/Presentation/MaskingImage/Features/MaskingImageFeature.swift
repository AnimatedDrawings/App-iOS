//
//  MaskingImageFeature.swift
//  MaskingImage
//
//  Created by chminii on 1/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib

public struct MaskingImageFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    MainReducer()
  }
}

public extension MaskingImageFeature {
  struct State: Equatable {
    public init() {}
  }
}

public extension MaskingImageFeature {
  enum Action: Equatable {}
}

extension MaskingImageFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      }
    }
  }
}
