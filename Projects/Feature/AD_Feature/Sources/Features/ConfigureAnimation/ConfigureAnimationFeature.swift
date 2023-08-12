//
//  ConfigureAnimationFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct ConfigureAnimationFeature: Reducer {
  @Dependency(\.configureAnimationClient) var configureAnimationClient
  
  public init() {}
  
  public typealias State = TCABaseState<ConfigureAnimationFeature.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var isShowAnimationListView = false
    public var isShowLoadingView = false
    
    public var selectedAnimation: ADAnimation? = nil
    public var cache: [ADAnimation : Data?] = ADAnimation.allCases
      .reduce(into: [ADAnimation : Data?]()) { dict, key in
        dict[key] = nil
      }
    public var myAnimation: Data? = nil
    var isSuccessAddAnimation = false
    
    @BindingState public var isShowAlert = false
    public var titleAlert = ""
    public var descriptionAlert = ""
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case toggleIsShowAnimationListView
    case toggleIsShowAddAnimationView
    
    case setLoadingView(Bool)
    case selectAnimation(ADAnimation)
    case addAnimationResponse(TaskResult<EmptyResponse>)
    case downloadVideo
    case downloadVideoResponse(TaskResult<Data>)
    case onDismissAnimationListView
    
    case addToCache(Data)
    
    case showAlert(ADError)
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
        state.selectedAnimation = animation
        if let tmpGifDataInCache = state.cache[animation],
           let gifDataInCache = tmpGifDataInCache
        {
          state.isSuccessAddAnimation = true
          state.myAnimation = gifDataInCache
          state.isSuccessAddAnimation = true
          return .send(.toggleIsShowAnimationListView)
        }
        
        guard let ad_id = state.sharedState.ad_id else {
          return .none
        }
        
        let request = ConfigureAnimationRequest(
          ad_id: ad_id,
          adAnimationDTO: .init(adAnimation: animation)
        )
        
        return .run { send in
          await send(.setLoadingView(true))
          await send(
            .addAnimationResponse(
              TaskResult {
                try await configureAnimationClient.add(request)
              }
            )
          )
        }
        
      case .addAnimationResponse(.success):
        return .send(.downloadVideo)
        
      case .addAnimationResponse(.failure(let error)):
        print(error)
        let adError = error as? ADError ?? .connection
        return .run { send in
          await send(.setLoadingView(true))
          await send(.showAlert(adError))
        }
        
      case .downloadVideo:
        guard let ad_id = state.sharedState.ad_id,
              let selectedAnimation = state.selectedAnimation
        else {
          return .none
        }
        
        let request = ConfigureAnimationRequest(
          ad_id: ad_id,
          adAnimationDTO: .init(adAnimation: selectedAnimation)
        )
        
        return .run { send in
          await send(
            .downloadVideoResponse(
              TaskResult {
                try await configureAnimationClient.downloadVideo(request)
              }
            )
          )
        }
        
      case .downloadVideoResponse(.success(let response)):
        state.isSuccessAddAnimation = true
        return .run { send in
          await send(.addToCache(response))
          await send(.setLoadingView(false))
          await send(.toggleIsShowAnimationListView)
        }
        
      case .downloadVideoResponse(.failure(let error)):
        print(error)
        let adError = error as? ADError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlert(adError))
        }
        
      case .onDismissAnimationListView:
        if state.isSuccessAddAnimation {
          guard let selectedAnimation = state.selectedAnimation,
                let tmpGifDataInCache = state.cache[selectedAnimation],
                let gifDataInCache = tmpGifDataInCache
          else {
            return .none
          }
          
          state.myAnimation = gifDataInCache
          state.isSuccessAddAnimation = false
        }
        return .none
        
      case .addToCache(let data):
        guard let selectedAnimation = state.selectedAnimation else {
          return .none
        }
        state.cache[selectedAnimation] = data
        print(data)
        return .none
        
      case .showAlert(let adError):
        state.titleAlert = adError.title
        state.descriptionAlert = adError.description
        state.isShowAlert.toggle()
        return .none
      }
    }
  }
}
