//
//  MaskingImageFeature.swift
//  MaskingImage
//
//  Created by chminii on 1/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit
import SharedProvider

public struct MaskingImageFeature: Reducer {
  @Dependency(\.shared.makeAD.maskedImage) var maskedImage
  
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
    
    public var undoTrigger = false
    public var resetTrigger = false
    public var saveTrigger = false
    
    public init(
      drawingState: DrawingTool = .erase,
      circleRadius: CGFloat = 0
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
    case saveMaskedImage(UIImage?)
    
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
        state.saveTrigger.toggle()
        return .none
      case .saveMaskedImage(let image):
        return .run { _ in
          await maskedImage.set(image)
        }
        
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
