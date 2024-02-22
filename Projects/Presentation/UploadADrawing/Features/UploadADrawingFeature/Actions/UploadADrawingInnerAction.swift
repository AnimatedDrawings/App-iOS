//
//  UploadADrawingInnerAction.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel

public extension UploadADrawingFeature {
  enum InnerAction: Equatable {
    case setLoadingView(Bool)
    case moveToFindingTheCharacter
    
    case showNetworkErrorAlert
    case showFindCharacterErrorAlert
    case showImageSizeErrorAlert
  }
  
  func InnerReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .inner(let innerAction):
        switch innerAction {
        case .setLoadingView(let flag):
          state.isShowLoadingView = flag
          return .none
          
        case .moveToFindingTheCharacter:
          state.stepBar = StepBarState(
            isShowStepBar: true,
            currentStep: .FindingTheCharacter,
            completeStep: .UploadADrawing
          )
          return .none
          
        case .showNetworkErrorAlert:
          state.isShowNetworkErrorAlert.toggle()
          return .none
          
        case .showFindCharacterErrorAlert:
          state.isShowFindCharacterErrorAlert.toggle()
          return .none
          
        case .showImageSizeErrorAlert:
          state.isShowImageSizeErrorAlert.toggle()
          return .none
        }
      default:
        return .none
      }
    }
  }
}
