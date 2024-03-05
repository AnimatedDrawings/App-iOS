//
//  MakeADScopeAction.swift
//  MakeADExample
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UploadADrawingFeatures
import FindingTheCharacterFeatures
import CropImageFeatures
import DomainModel

public extension MakeADFeature {
  @CasePathable
  enum ScopeActions: Equatable {
    case uploadADrawing(UploadADrawingFeature.Action)
    case findingTheCharacter(FindingTheCharacterFeature.Action)
  }
  
  func UploadADrawingReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .scope(.uploadADrawing(.delegate(let uploadADrawingActions))):
        switch uploadADrawingActions {
        case .setOriginalImage(let originalImage):
          state.makeADInfo.originalImage = originalImage
          return .none
          
        case .setBoundingBox(let boundingBox):
          state.makeADInfo.boundingBox = boundingBox
          return .none
          
        case .moveToFindingTheCharacter:
          if let originalImage = state.makeADInfo.originalImage,
             let boundingBox = state.makeADInfo.boundingBox {
            state.findTheCharacter.cropImage = CropImageFeature.State(
              originalImage: originalImage,
              boundingBox: boundingBox
            )
            
            state.stepBar = StepBarState(
              isShowStepBar: true,
              currentStep: .FindingTheCharacter,
              completeStep: .UploadADrawing
            )
          }
          return .none
        }
        
      default:
        return .none
      }
    }
  }
  
  func FindTheCharacterReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .scope(.findingTheCharacter(let findingTheCharacterActions)):
        switch findingTheCharacterActions {
        case .delegate(.setMaskImage(let maskImage)):
          state.makeADInfo.maskedImage = maskImage
          return .none
        case .delegate(.moveToSeparatingCharacter):
          state.stepBar = StepBarState(
            isShowStepBar: true,
            currentStep: .SeparatingCharacter,
            completeStep: .FindingTheCharacter
          )
          return .none
        default:
          return .none
        }
      default:
        return .none
      }
    }
  }
}
