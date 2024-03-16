//
//  StepProvider.swift
//  SharedProvider
//
//  Created by chminii on 3/8/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import DomainModels
import ADComposableArchitecture

public struct StepProvider {
  public var isShowStepBar: CombineNotifier<Bool>
  public var currentStep: CombineNotifier<MakeADStep>
  public var completeStep: CombineNotifier<MakeADStep>
  
  public init(
    isShowStepBar: Bool = true,
    currentStep: MakeADStep = .UploadADrawing,
    completeStep: MakeADStep = .None
  ) {
    self.isShowStepBar = .init(initialValue: isShowStepBar)
    self.currentStep = .init(initialValue: currentStep)
    self.completeStep = .init(initialValue: completeStep)
  }
}

extension StepProvider: DependencyKey {
  public static let liveValue = Self()
  public static let testValue = Self()
}
