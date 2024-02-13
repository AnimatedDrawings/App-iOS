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
    BindingReducer()
    MainReducer()
  }
}

public extension MakeADFeature {
  struct State: Equatable {
    @BindingState public var stepBar: StepBarState
    
    public init(
      stepBar: StepBarState = .init()
    ) {
      self.stepBar = stepBar
    }
  }
}

public struct StepBarState: Equatable {
  public var isShowStepBar: Bool
  public var currentStep: Step
  public var completeStep: Step
  
  public init(
    isShowStepBar: Bool = true,
    currentStep: Step = .UploadADrawing,
    completeStep: Step = .None
  ) {
    self.isShowStepBar = isShowStepBar
    self.currentStep = currentStep
    self.completeStep = completeStep
  }
}

public extension MakeADFeature {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
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
