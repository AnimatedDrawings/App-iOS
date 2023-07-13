//
//  FindingTheCharacterStore.swift
//  AD_Feature
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct FindingTheCharacterStore: ReducerProtocol {
  @Dependency(\.adClient) var adClient
  
  public init() {}
  public typealias State = TCABaseState<FindingTheCharacterStore.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState = false
    @BindingState public var isShowCropImageView = false
    var isNewCropImage = false
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case checkAction
    case toggleCropImageView
    case cropNextAction(Bool)
    case onDismissCropImageView
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkAction:
        state.checkState.toggle()
        return .none
        
      case .toggleCropImageView:
        state.isShowCropImageView.toggle()
        return .none
        
      case .cropNextAction(let cropResult):
        state.isNewCropImage = cropResult
        return .task {
          .toggleCropImageView
        }
        
      case .onDismissCropImageView:
        if state.isNewCropImage == true {
          state.sharedState.completeStep = .SeparatingCharacter
          state.sharedState.currentStep = .SeparatingCharacter
        }
        state.isNewCropImage = false
        return .none
      }
    }
  }
}
