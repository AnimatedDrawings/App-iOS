//
//  MakeADFeature.swift
//  MakeADFeatures
//
//  Created by chminii on 2/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel
import UploadADrawingFeatures

public struct MakeADFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.uploadADrawing, action: /Action.uploadADrawing) {
      UploadADrawingFeature()
    }
    BindingReducer()
    MainReducer()
  }
}

public extension MakeADFeature {
  struct State: Equatable {
    @BindingState public var stepBar: StepBarState
    public var makeADInfo: MakeADInfo
    
    public var uploadADrawing: UploadADrawingFeature.State
    
    public init(
      stepBar: StepBarState = .init(),
      makeADInfo: MakeADInfo = .init(),
      uploadADrawing: UploadADrawingFeature.State = .init()
    ) {
      self.stepBar = stepBar
      self.makeADInfo = makeADInfo
      self.uploadADrawing = uploadADrawing
    }
  }
}

public extension MakeADFeature {
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case uploadADrawing(UploadADrawingFeature.Action)
  }
}

extension MakeADFeature {
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
