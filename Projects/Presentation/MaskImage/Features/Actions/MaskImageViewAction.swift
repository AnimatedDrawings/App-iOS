//
//  MaskImageViewAction.swift
//  MaskImageFeatures
//
//  Created by chminii on 3/28/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import MaskImageInterfaces
import Foundation

public extension MaskImageFeature {
  enum ViewActions: Equatable {
    case save
    case cancel
    case maskToolAction(MaskToolActions)
  }
  
  enum MaskToolActions: Equatable {
    case setDrawingTool(DrawingTool)
    case setMaskTool(MaskTool)
    case changeToolCircleSize(CGFloat)
  }
  
  func ViewReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .save:
          state.triggerState.save.toggle()
          return .none
        case .cancel:
          return .send(.delegate(.cancel))
          
        case .maskToolAction(let maskToolActions):
          switch maskToolActions {
          case .setDrawingTool(let drawingTool):
            state.triggerState.drawingTool = drawingTool
            return .none
          case .setMaskTool(let maskTool):
            state.triggerState.maskTool = maskTool
            return .none
          case .changeToolCircleSize(let toolCircleSize):
            state.toolCircleSize = toolCircleSize
            return .none
          }
        }
      default:
        return .none
      }
    }
  }
}
