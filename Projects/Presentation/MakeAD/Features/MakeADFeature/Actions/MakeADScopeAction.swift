//
//  MakeADScopeAction.swift
//  MakeADExample
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UploadADrawingFeatures

public extension MakeADFeature {
  @CasePathable
  enum ScopeAction: Equatable {
    case uploadADrawing(UploadADrawingFeature.Action)
  }
  
  func ScopeReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .scope(.uploadADrawing(.delegate(let uploadADrawingAction))):
        switch uploadADrawingAction {
        case .setOriginalImage(let originalImage):
          state.makeADInfo.originalImage = originalImage
          return .none
          
        case .setBoundingBox(let boundingBox):
          state.makeADInfo.boundingBox = boundingBox
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}
