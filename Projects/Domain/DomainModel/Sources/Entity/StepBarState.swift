//
//  StepBarState.swift
//  DomainModel
//
//  Created by chminii on 2/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

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
