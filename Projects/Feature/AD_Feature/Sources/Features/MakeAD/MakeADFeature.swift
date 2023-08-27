//
//  MakeADFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct MakeADFeature: Reducer {
  public init() {}
  
  public typealias State = TCABaseState<MakeADFeature.MyState>
  
  public struct MyState: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case setCurrentStep(Step)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .setCurrentStep(let nexStep):
        if state.sharedState.currentStep != nexStep {
          state.sharedState.isShowStepStatusBar = true
          state.sharedState.currentStep = nexStep
        }
        return .none
      }
    }
  }
}
