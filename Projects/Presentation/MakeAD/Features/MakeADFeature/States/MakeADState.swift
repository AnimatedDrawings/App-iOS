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
    public var stepBar: StepBarState
    public var makeADInfo: MakeADInfo
    public var uploadADrawing: UploadADrawingFeature.State
    public var findTheCharacter: FindingTheCharacterFeature.State
    
    public init(
      stepBar: StepBarState = .init(),
      makeADInfo: MakeADInfo = .init(),
      uploadADrawing: UploadADrawingFeature.State = .init(),
      findTheCharacter: FindingTheCharacterFeature.State = .init()
    ) {
      self.stepBar = stepBar
      self.makeADInfo = makeADInfo
      self.uploadADrawing = uploadADrawing
      self.findTheCharacter = findTheCharacter
    }
  }
}
