//
//  FindingTheCharacterStore.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct FindingTheCharacterStore: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    public init(
      originalImage: UIImage?
    ) {
      self.originalImage = originalImage
    }
    
    public var originalImage: UIImage?
    @BindingState public var checkState = false
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case checkAction
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkAction:
        state.checkState.toggle()
        return .none
      }
    }
  }
}
