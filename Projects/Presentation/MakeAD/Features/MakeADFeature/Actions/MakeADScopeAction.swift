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
          }
          return .run { send in
            await stepBar.isShowStepBar.set(true)
            await stepBar.currentStep.set(.FindingTheCharacter)
            await stepBar.completeStep.set(.UploadADrawing)
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
        case .delegate(.setMaskImage(let maskImage)):
          state.makeADInfo.maskedImage = maskImage
          return .none
        case .delegate(.moveToSeparatingCharacter):
          return .run { send in
            await stepBar.isShowStepBar.set(true)
            await stepBar.currentStep.set(.SeparatingCharacter)
            await stepBar.completeStep.set(.FindingTheCharacter)
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
