//
//  MakeADState.swift
//  MakeADExample
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel
import UploadADrawingFeatures
import FindingTheCharacterFeatures

public extension MakeADFeature {
  @ObservableState
  struct State: Equatable {
    public var step: StepState
    public var makeADInfo: MakeADInfo
    public var uploadADrawing: UploadADrawingFeature.State
    public var findingTheCharacter: FindingTheCharacterFeature.State
    
    public init(
      step: StepState = .init(),
      makeADInfo: MakeADInfo = .init(),
      uploadADrawing: UploadADrawingFeature.State = .init(),
      findingTheCharacter: FindingTheCharacterFeature.State = .init()
    ) {
      self.step = step
      self.makeADInfo = makeADInfo
      self.uploadADrawing = uploadADrawing
      self.findingTheCharacter = findingTheCharacter
    }
  }
  
  @ObservableState
  struct StepState: Equatable {
    public var isShowStepBar: Bool
    public var currentStep : MakeADStep
    public var completeStep: MakeADStep
    
    public init(
      isShowStepBar: Bool = true,
      currentStep: MakeADStep = .UploadADrawing,
      completeStep: MakeADStep = .None
    ) {
      self.isShowStepBar = isShowStepBar
      self.currentStep = currentStep
      self.completeStep = completeStep
    }
  }
}
