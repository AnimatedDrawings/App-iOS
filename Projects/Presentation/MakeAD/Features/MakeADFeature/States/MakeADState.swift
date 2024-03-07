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
    public var findTheCharacter: FindingTheCharacterFeature.State
    
    public init(
      step: StepState = .init(),
      makeADInfo: MakeADInfo = .init(),
      uploadADrawing: UploadADrawingFeature.State = .init(),
      findTheCharacter: FindingTheCharacterFeature.State = .init()
    ) {
      self.step = step
      self.makeADInfo = makeADInfo
      self.uploadADrawing = uploadADrawing
      self.findTheCharacter = findTheCharacter
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
