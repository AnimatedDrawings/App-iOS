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
import SeparateCharacterFeatures
import FindCharacterJointsFeatures
import DomainModels

public extension MakeADFeature {
  @CasePathable
  enum ScopeActions: Equatable {
    case uploadDrawing(UploadDrawingFeature.Action)
    case findTheCharacter(FindTheCharacterFeature.Action)
    case separateCharacter(SeparateCharacterFeature.Action)
    case findCharacterJoints(FindCharacterJointsFeature.Action)
  }
  
  func ScopeReducer() -> some ReducerOf<Self> {
    CombineReducers {
      UploadDrawingReducer()
      FindTheCharacterReducer()
      SeparateCharacterReducer()
      FindCharacterJointsReducer()
    }
  }
  
  func UploadDrawingReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(.uploadDrawing(.delegate(let uploadDrawingActions))):
        switch uploadDrawingActions {
        case .moveToFindTheCharacter(let result):
          state.makeADInfo.originalImage = result.originalImage
          state.makeADInfo.boundingBox = result.boundingBox.cgRect
          state.findTheCharacter.cropImage = .init(
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
          state.separateCharacter.maskImage = .init(
            croppedImage: result.cropImage,
            maskedImage: result.maskImage
          )
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
  
  func SeparateCharacterReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(.separateCharacter(let separateCharacterActions)):
        switch separateCharacterActions {
        case .delegate(.moveToFindCharacterJoints(let result)):
          guard let croppedImage = state.makeADInfo.croppedImage else {
            return .none
          }
          
          state.makeADInfo.joints = result.joints
          state.makeADInfo.maskedImage = result.maskedImage
          state.findCharacterJoints.modifyJoints = .init(
            originJoints: result.joints,
            croppedImage: croppedImage
          )
          return .run { send in
            await step.isShowStepBar.set(true)
            await step.currentStep.set(.FindCharacterJoints)
            await step.completeStep.set(.SeparateCharacter)
          }
          
        default:
          return .none
        }
        
      default:
        return .none
      }
    }
  }
  
  func FindCharacterJointsReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scope(.findCharacterJoints(let findCharacterJointsActions)):
        switch findCharacterJointsActions {
        case .delegate(.findCharacterJointsResult):
          return .run { send in
            await step.completeStep.set(.FindCharacterJoints)
            await adViewState.adViewState.set(.ConfigureAnimation)
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
