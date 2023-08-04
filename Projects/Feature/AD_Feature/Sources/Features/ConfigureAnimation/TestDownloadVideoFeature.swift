//
//  TestDownloadVideoFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/08/04.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct TestDownloadVideoFeature: Reducer {
  @Dependency(\.configureAnimationClient) var configureAnimationClient
  
  public init() {}

  public struct State: Equatable {
    public init() {}

    public var gifData: Data? = nil
    public var downloadState: String = "end"
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)

    case downloadVideo
    case downloadVideoResponse(TaskResult<Data>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .downloadVideo:
        let ad_id = "91c4ec7510cf4c08a38a734ed59996bc_20230804072240"
        let adAnimation: ADAnimation = .dab
        
        let request = ConfigureAnimationRequest(ad_id: ad_id, name: adAnimation.rawValue)
        
        state.downloadState = "start"
        
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
        state.downloadState = "end"
        print(response)
        state.gifData = response
        return .none
        
      case .downloadVideoResponse(.failure(let error)):
        print(error)
        return .none
      }
    }
  }
}
