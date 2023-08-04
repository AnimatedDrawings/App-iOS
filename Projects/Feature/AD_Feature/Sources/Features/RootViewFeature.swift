//
//  RootViewFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/31.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct RootViewFeature: Reducer {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
    
    @BindingState public var isTapStartButton = false
    
    public var sharedState = SharedState()

    private var _makeADState = MakeADFeature.MyState()
    public var makeADState: MakeADFeature.State {
      get {
        return TCABaseState(sharedState: sharedState, state: _makeADState)
      }
      set {
        self.sharedState = newValue.sharedState
        self._makeADState = newValue.state
      }
    }
    
    private var _uploadADrawingState = UploadADrawingFeature.MyState()
    public var uploadADrawingState: UploadADrawingFeature.State {
      get {
        TCABaseState(sharedState: sharedState, state: _uploadADrawingState)
      }
      set {
        self.sharedState = newValue.sharedState
        self._uploadADrawingState = newValue.state
      }
    }
    
    private var _findingTheCharacterState = FindingTheCharacterFeature.MyState()
    public var findingTheCharacterState: FindingTheCharacterFeature.State {
      get {
        TCABaseState(sharedState: sharedState, state: _findingTheCharacterState)
      }
      set {
        self.sharedState = newValue.sharedState
        self._findingTheCharacterState = newValue.state
      }
    }
    
    private var _separatingCharacterState = SeparatingCharacterFeature.MyState()
    public var separatingCharacterState: SeparatingCharacterFeature.State {
      get {
        TCABaseState(sharedState: sharedState, state: _separatingCharacterState)
      }
      set {
        self.sharedState = newValue.sharedState
        self._separatingCharacterState = newValue.state
      }
    }
    
    public var _findingCharacterJointsState = FindingCharacterJointsFeature.MyState()
    public var findingCharacterJointsState: FindingCharacterJointsFeature.State {
      get {
        TCABaseState(sharedState: sharedState, state: _findingCharacterJointsState)
      }
      set {
        self.sharedState = newValue.sharedState
        self._findingCharacterJointsState = newValue.state
      }
    }
    
    private var _addAnimationState = ConfigureAnimationFeature.MyState()
    public var addAnimationState: ConfigureAnimationFeature.State {
      get {
        return TCABaseState(sharedState: sharedState, state: _addAnimationState)
      }
      set {
        self.sharedState = newValue.sharedState
        self._addAnimationState = newValue.state
      }
    }
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case makeADAction(MakeADFeature.Action)
    case uploadADrawingAction(UploadADrawingFeature.Action)
    case findingTheCharacterAction(FindingTheCharacterFeature.Action)
    case separatingCharacterAction(SeparatingCharacterFeature.Action)
    case findingCharacterJointsAction(FindingCharacterJointsFeature.Action)
    case addAnimationAction(ConfigureAnimationFeature.Action)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Scope(state: \.makeADState, action: /Action.makeADAction) {
      MakeADFeature()
    }
    
    Scope(state: \.uploadADrawingState, action: /Action.uploadADrawingAction) {
      UploadADrawingFeature()
    }

    Scope(state: \.findingTheCharacterState, action: /Action.findingTheCharacterAction) {
      FindingTheCharacterFeature()
    }

    Scope(state: \.separatingCharacterState, action: /Action.separatingCharacterAction) {
      SeparatingCharacterFeature()
    }

    Scope(state: \.findingCharacterJointsState, action: /Action.findingCharacterJointsAction) {
      FindingCharacterJointsFeature()
    }
    
    Scope(state: \.addAnimationState, action: /Action.addAnimationAction) {
      ConfigureAnimationFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .makeADAction,
          .uploadADrawingAction,
          .findingTheCharacterAction,
          .separatingCharacterAction,
          .findingCharacterJointsAction,
          .addAnimationAction:
        return .none
      }
    }
  }
}
