//
//  UploadADrawingStore.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils
import ComposableArchitecture

public struct UploadADrawingStore: ReducerProtocol {
  public init() {}
  public typealias State = TCABaseState<UploadADrawingStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState1 = false
    @BindingState public var checkState2 = false
    @BindingState public var checkState3 = false
    @BindingState public var uploadState = false
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkAction1
    case checkAction2
    case checkAction3
    case uploadAction
    case sampleTapAction(UIImage)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkAction1:
        state.checkState1.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .checkAction2:
        state.checkState2.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .checkAction3:
        state.checkState3.toggle()
        activeUploadButton(state: &state)
        return .none
        
      case .uploadAction:
        print("uploadAction")
        return .none
        
      case .sampleTapAction(let image):
        print("sampleTapAction")
        state.sharedState.originalImage = image
        state.sharedState.curStep = .FindingTheCharacter
        return .none
      }
    }
  }
  
  func activeUploadButton(state: inout UploadADrawingStore.State) {
    if state.checkState1 && state.checkState2 && state.checkState3 {
      state.uploadState = true
    } else {
      state.uploadState = false
    }
  }
}
