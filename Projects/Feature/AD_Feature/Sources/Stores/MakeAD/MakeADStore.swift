//
//  MakeADStore.swift
//  AD_Feature
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct MakeADStore: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
    
    public var sharedState = SharedState()
    
    public var _uploadADrawing = UploadADrawingStore.MyState()
    public var uploadADrawing: TCABaseState<UploadADrawingStore.MyState> {
      get {
        TCABaseState(sharedState: sharedState, state: _uploadADrawing)
      }
      set {
        self.sharedState = newValue.sharedState
        self._uploadADrawing = newValue.state
      }
    }
    
    public var _findingTheCharacter = FindingTheCharacterStore.MyState()
    public var findingTheCharacter: TCABaseState<FindingTheCharacterStore.MyState> {
      get {
        TCABaseState(sharedState: sharedState, state: _findingTheCharacter)
      }
      set {
        self.sharedState = newValue.sharedState
        self._findingTheCharacter = newValue.state
      }
    }
    
    public var _separatingCharacter = SeparatingCharacterStore.MyState()
    public var separatingCharacter: TCABaseState<SeparatingCharacterStore.MyState> {
      get {
        TCABaseState(sharedState: sharedState, state: _separatingCharacter)
      }
      set {
        self.sharedState = newValue.sharedState
        self._separatingCharacter = newValue.state
      }
    }
    
    public var _findingCharacterJoints = FindingCharacterJointsStore.MyState()
    public var findingCharacterJoints: TCABaseState<FindingCharacterJointsStore.MyState> {
      get {
        TCABaseState(sharedState: sharedState, state: _findingCharacterJoints)
      }
      set {
        self.sharedState = newValue.sharedState
        self._findingCharacterJoints = newValue.state
      }
    }
    
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case bindingCurrentStep(Step)
    
    case uploadADrawing(UploadADrawingStore.Action)
    case findingTheCharacter(FindingTheCharacterStore.Action)
    case separatingCharacter(SeparatingCharacterStore.Action)
    case findingCharacterJoints(FindingCharacterJointsStore.Action)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Scope(state: \.uploadADrawing, action: /Action.uploadADrawing) {
      UploadADrawingStore()
    }
    
    Scope(state: \.findingTheCharacter, action: /Action.findingTheCharacter) {
      FindingTheCharacterStore()
    }
    
    Scope(state: \.separatingCharacter, action: /Action.separatingCharacter) {
      SeparatingCharacterStore()
    }
    
    Scope(state: \.findingCharacterJoints, action: /Action.findingCharacterJoints) {
      FindingCharacterJointsStore()
    }
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .bindingCurrentStep(let nexStep):
        if state.sharedState.currentStep != nexStep {
          state.sharedState.currentStep = nexStep
          withAnimation {
            state.sharedState.isShowStepStatusBar = true
          }
        }
        return .none
        
      case .uploadADrawing, .findingTheCharacter, .separatingCharacter, .findingCharacterJoints:
        return .none
      }
    }
  }
}
