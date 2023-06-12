//
//  MakeADStore.swift
//  AD_Feature
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct MakeADStore: ReducerProtocol {
  public init() {}
  
  public enum Step: Int {
    case UploadADrawing = 1
    case FindingTheCharacter = 2
    
    var index: Int {
      return self.rawValue
    }
  }
  
  public struct State: Equatable {
    public init() {}
    
    @BindingState public var curStep: Step = .UploadADrawing
    public var uploadADrawing = UploadADrawingStore.State()
    public var findingTheCharacter = FindingTheCharacterStore.State()
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case upStep
    case downStep
    case uploadADrawing(UploadADrawingStore.Action)
    case findingTheCharacter(FindingTheCharacterStore.Action)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Scope(state: \.uploadADrawing, action: /Action.uploadADrawing) {
      UploadADrawingStore()
    }
    
    Scope(state: \.findingTheCharacter, action: /Action.findingTheCharacter) {
      FindingTheCharacterStore()
    }
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      // 안쓰면 지우기
      case .upStep:
        let nexIndex = state.curStep.index + 1
        guard nexIndex != 5,
              let nexStep = Step.init(rawValue: nexIndex)
        else {
          return .none
        }
        state.curStep = nexStep
        return .none
        
      case .downStep:
        let nexIndex = state.curStep.index - 1
        guard nexIndex != 0,
              let nexStep = Step.init(rawValue: nexIndex)
        else {
          return .none
        }
        state.curStep = nexStep
        return .none
        
      case .uploadADrawing, .findingTheCharacter:
        return .none
      }
    }
  }
}
