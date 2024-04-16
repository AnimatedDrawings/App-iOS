//
//  MakeADScopeAction.swift
//  MakeADExample
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import UploadDrawingFeatures
import FindTheCharacterFeatures
import CropImageFeatures
import DomainModels

public extension MakeADFeature {
  @CasePathable
  enum ScopeActions: Equatable {
    case uploadDrawing(UploadDrawingFeature.Action)
    case findTheCharacter(FindTheCharacterFeature.Action)
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
      case .scope(.uploadDrawing(.delegate(let uploadDrawingActions))):
        switch uploadDrawingActions {
        case .moveToFindingTheCharacter(let result):
          state.makeADInfo.originalImage = result.originalImage
          state.makeADInfo.boundingBox = result.boundingBox.cgRect
          state.findTheCharacter.cropImage = CropImageFeature.State(
            originalImage: result.originalImage,
            boundingBox: result.boundingBox
          )
          
          return .run { send in
            await step.isShowStepBar.set(true)
            await step.currentStep.set(.FindTheCharacter)
            await step.completeStep.set(.UploadDrawing)
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
      case .scope(.findTheCharacter(let findTheCharacterActions)):
        switch findTheCharacterActions {
        case .delegate(.moveToSeparateCharacter(let result)):
          state.makeADInfo.croppedImage = result.cropImage
          state.makeADInfo.maskedImage = result.maskImage
          return .run { send in
            await step.isShowStepBar.set(true)
            await step.currentStep.set(.SeparateCharacter)
            await step.completeStep.set(.FindTheCharacter)
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
