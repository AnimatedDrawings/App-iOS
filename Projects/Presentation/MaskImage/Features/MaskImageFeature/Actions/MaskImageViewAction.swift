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
    case setMaskCache(MaskCacheActions)
    case changeToolCircleSize(CGFloat)
  }
  
  enum MaskCacheActions: Equatable {
    case undo
    case reset
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
          case .setMaskCache(let maskCaches):
            switch maskCaches {
            case .undo:
              state.triggerState.maskCache.undo.toggle()
            case .reset:
              state.triggerState.maskCache.reset.toggle()
            }
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
