//
//  MakeADFeature.swift
//  MakeADFeatures
//
//  Created by chminii on 2/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel

public struct MakeADFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.stepBar, action: /Action.stepBar) {
      StepBarFeature()
    }
    MainReducer()
  }
}

public extension MakeADFeature {
  struct State: Equatable {
    @BindingState public var stepBar: StepBarFeature.State
    
    public init(
      stepBar: StepBarFeature.State = .init()
    ) {
      self.stepBar = stepBar
    }
  }
}

public extension MakeADFeature {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case stepBar(StepBarFeature.Action)
  }
}

extension MakeADFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      }
    }
  }
}
