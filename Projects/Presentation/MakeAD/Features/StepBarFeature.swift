//
//  StepBarFeature.swift
//  MakeADFeatures
//
//  Created by chminii on 2/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel

public struct StepBarFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    MainReducer()
  }
}

public extension StepBarFeature {
  struct State: Equatable {
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
}

public extension StepBarFeature {
  enum Action: Equatable {}
}

extension StepBarFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      }
    }
  }
}
