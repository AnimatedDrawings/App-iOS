//
//  MakeADState.swift
//  MakeADExample
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import UploadDrawingFeatures
import FindTheCharacterFeatures
import SeparateCharacterFeatures
import FindCharacterJointsFeatures

public extension MakeADFeature {
  @ObservableState
  struct State: Equatable {
    public var step: StepState
    public var makeADInfo: MakeADInfo
    
    public var uploadDrawing: UploadDrawingFeature.State
    public var findTheCharacter: FindTheCharacterFeature.State
    public var separateCharacter: SeparateCharacterFeature.State
    public var findCharacterJoints: FindCharacterJointsFeature.State
    
    public init(
      step: StepState = .init(),
      makeADInfo: MakeADInfo = .init(),
      uploadDrawing: UploadDrawingFeature.State = .init(),
      findTheCharacter: FindTheCharacterFeature.State = .init(),
      separateCharacter: SeparateCharacterFeature.State = .init(),
      findCharacterJoints: FindCharacterJointsFeature.State = .init()
    ) {
      self.step = step
      self.makeADInfo = makeADInfo
      self.uploadDrawing = uploadDrawing
      self.findTheCharacter = findTheCharacter
      self.separateCharacter = separateCharacter
      self.findCharacterJoints = findCharacterJoints
    }
  }
  
  @ObservableState
  struct StepState: Equatable {
    public var isShowStepBar: Bool
    public var currentStep : MakeADStep
    public var completeStep: MakeADStep
    
    public init(
      isShowStepBar: Bool = true,
      currentStep: MakeADStep = .UploadDrawing,
      completeStep: MakeADStep = .None
    ) {
      self.isShowStepBar = isShowStepBar
      self.currentStep = currentStep
      self.completeStep = completeStep
    }
  }
}
