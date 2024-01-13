//
//  MaskingImageFeature.swift
//  MaskingImage
//
//  Created by chminii on 1/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

public struct MaskingImageFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
  }
}

public extension MaskingImageFeature {
  struct State: Equatable {
    public var drawingState: DrawingTool
    @BindingState public var circleRadius: CGFloat
    public var maskedImage: UIImage?
    
    public var undoTrigger = false
    public var resetTrigger = false
    
    public init(
      drawingState: DrawingTool = .erase,
      circleRadius: CGFloat = 0,
      maskedImage: UIImage? = nil
    ) {
      self.drawingState = drawingState
      self.circleRadius = circleRadius
    }
  }
}

public extension MaskingImageFeature {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case selectTool(MaskTool)
    
    case saveAction
    case cropImage
    
    case cancelAction
    case undoAction
    case resetAction
  }
}

extension MaskingImageFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .selectTool(let maskTool):
        switch maskTool {
        case .undo:
          return .send(.undoAction)
        case .reset:
          return .send(.resetAction)
        case .drawingTool(let drawingTool):
          state.drawingState = drawingTool
          return .none
        }
        
      case .saveAction:
        return .run { send in
          await send(.cropImage)
        }
        
      case .cropImage:
        return .none
        
      case .cancelAction:
        return .none
        
      case .undoAction:
        state.undoTrigger.toggle()
        return .none
        
      case .resetAction:
        state.resetTrigger.toggle()
        return .none
      }
    }
  }
}

public enum DrawingTool: Equatable {
  case draw
  case erase
}

public enum MaskTool: Equatable {
  case drawingTool(DrawingTool)
  case undo
  case reset
}
