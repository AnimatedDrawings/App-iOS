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
  public var isShowStepBar: GlobalNotifier<Bool>
  public var currentStep: GlobalNotifier<MakeADStep>
  public var completeStep: GlobalNotifier<MakeADStep>
  
  public init(
    isShowStepBar: Bool = true,
    currentStep: MakeADStep = .UploadDrawing,
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
