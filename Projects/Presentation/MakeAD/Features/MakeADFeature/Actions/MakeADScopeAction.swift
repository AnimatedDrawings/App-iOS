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
  
  func ScopeReducer() -> some ReducerOf<Self> {
    CombineReducers {
      UploadADrawingReducer()
      FindTheCharacterReducer()
    }
  }
  
  func UploadADrawingReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(.uploadADrawing(.delegate(let uploadADrawingActions))):
        switch uploadADrawingActions {
        case .moveToFindingTheCharacter(let result):
          state.makeADInfo.originalImage = result.originalImage
          state.makeADInfo.boundingBox = result.boundingBox
          state.findingTheCharacter.cropImage = CropImageFeature.State(
            originalImage: result.originalImage,
            boundingBox: result.boundingBox
          )
          
          return .run { send in
            await step.isShowStepBar.set(true)
            await step.currentStep.set(.FindingTheCharacter)
            await step.completeStep.set(.UploadADrawing)
          }
        }
        
      default:
        return .none
      }
    }
  }
  
  func FindTheCharacterReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(.findingTheCharacter(let findingTheCharacterActions)):
        switch findingTheCharacterActions {
        case .delegate(.moveToSeparatingCharacter(let result)):
          state.makeADInfo.croppedImage = result.cropImage
          state.makeADInfo.maskedImage = result.maskImage
          return .run { send in
            await step.isShowStepBar.set(true)
            await step.currentStep.set(.SeparatingCharacter)
            await step.completeStep.set(.FindingTheCharacter)
          }
        default:
          return .none
        }
      default:
        return .none
      }
    }
  }
}
