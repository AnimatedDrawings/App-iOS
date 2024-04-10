//
//  FindCharacterJointsAsyncAction.swift
//  FindCharacterJointsFeatures
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels

public extension FindCharacterJointsFeature {
  enum AsyncActions: Equatable {
    case findCharacterJoints(Joints)
    case findCharacterJointsResponse(TaskEmptyResult)
  }
  
  func AsyncReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .async(let asyncActions):
        switch asyncActions {
        case .findCharacterJoints(let joints):
          return .run { send in
            guard let ad_id = await adInfo.id.get() else { return }
            await send(.inner(.setLoadingView(true)))
            await send(.async(.findCharacterJointsResponse(
              TaskResult.empty {
                try await makeADProvider.findCharacterJoints(ad_id: ad_id, joints: joints)
              }
            )))
          }
          
        case .findCharacterJointsResponse(.success):
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            // delegate
          }
          
        case .findCharacterJointsResponse(.failure(let error)):
          print(error)
          return .run { send in
            await send(.inner(.setLoadingView(false)))
            await send(.inner(.networkErrorAlert))
          }
        }
        
      default:
        return .none
      }
    }
  }
}
