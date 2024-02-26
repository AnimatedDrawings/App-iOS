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

@Reducer
public struct MakeADFeature {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.uploadADrawing, action: \.scope.uploadADrawing) {
      UploadADrawingFeature()
    }
    
    BindingReducer()
    MainReducer()
    ScopeReducer()
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
  @CasePathable
  enum Action: Equatable, BindableAction, ScopeActions {
    case binding(BindingAction<State>)
    case scope(ScopeAction)
  }
  
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
