//
//  AddAnimationFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct AddAnimationFeature: Reducer {
  @Dependency(\.addAnimationClient) var addAnimationClient
  
  public init() {}
  
  public typealias State = TCABaseState<AddAnimationFeature.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var isShowAnimationListView = false
    public var isShowLoadingView = false
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case toggleIsShowAnimationListView
    case toggleIsShowAddAnimationView
    
    case setLoadingView(Bool)
    case selectAnimation(ADAnimation)
    case addAnimationResponse(TaskResult<AddAnimationResponse>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .toggleIsShowAnimationListView:
        state.isShowAnimationListView.toggle()
        return .none
        
      case .toggleIsShowAddAnimationView:
        state.sharedState.isShowAddAnimationView.toggle()
        return .none
        
      case .setLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case .selectAnimation(let animation):
        guard let ad_id = state.sharedState.ad_id else {
          return .none
        }
        let request = AddAnimationRequest(ad_id: ad_id, name: animation.rawValue)
        
        return .run { send in
          await send(.setLoadingView(true))
          await send(
            .addAnimationResponse(
              TaskResult {
                try await addAnimationClient.addAnimation(request)
              }
            )
          )
        }
        
      case .addAnimationResponse(.success(let response)):
        return .run { send in
          await send(.setLoadingView(false))
          await send(.toggleIsShowAnimationListView)
        }
        
      case .addAnimationResponse(.failure(let error)):
        return .send(.setLoadingView(false))
      }
    }
  }
}
