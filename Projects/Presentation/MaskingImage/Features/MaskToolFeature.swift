//
//  MaskToolFeature.swift
//  MaskingImage
//
//  Created by chminii on 1/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import Foundation

public struct MaskToolFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
  }
}

public extension MaskToolFeature {
  struct State: Equatable {
    public var drawingState: DrawingState
    @BindingState public var circleRadius: CGFloat
    
    public init(
      drawingState: DrawingState = .draw,
      circleRadius: CGFloat = 0
    ) {
      self.drawingState = drawingState
      self.circleRadius = circleRadius
    }
  }
  
  enum DrawingState: Equatable {
    case draw
    case erase
  }
}

public extension MaskToolFeature {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case draw
    case erase
    case undo
    case reset
  }
}

extension MaskToolFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      default:
        return .none
      }
    }
  }
}
