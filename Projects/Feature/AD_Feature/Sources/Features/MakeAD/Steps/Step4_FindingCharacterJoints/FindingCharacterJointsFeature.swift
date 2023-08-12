//
//  FindingCharacterJointsFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ComposableArchitecture

public struct FindingCharacterJointsFeature: Reducer {
  @Dependency(\.makeADClient) var makeADClient
  public init() {}
  
  public typealias State = TCABaseState<FindingCharacterJointsFeature.MyState>
  
  public struct MyState: Equatable {
    public init() {}
    
    @BindingState public var checkState = false
    @BindingState public var isShowModifyJointsView = false
    public var isShowLoadingView = false
    var isSuccessFindCharacterJoints = false
    
    @BindingState public var isShowAlert = false
    public var titleAlert = ""
    public var descriptionAlert = ""
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
    case bindIsShowStepStatusBar(Bool)
    
    case checkAction
    case toggleModifyJointsView
    
    case setLoadingView(Bool)
    case findCharacterJoints(JointsDTO)
    case findCharacterJointsResponse(TaskResult<EmptyResponse>)
    case onDismissModifyJointsView
    
    case showAlert(ADError)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .bindIsShowStepStatusBar(let flag):
        state.sharedState.isShowStepStatusBar = flag
        return .none
        
      case .checkAction:
        state.checkState.toggle()
        return .none
        
      case .toggleModifyJointsView:
        state.isShowModifyJointsView.toggle()
        return .none
        
      case .setLoadingView(let flag):
        state.isShowLoadingView = flag
        return .none
        
      case .findCharacterJoints(let jointsDTO):
        guard let ad_id = state.sharedState.ad_id else {
          return .none
        }
        state.sharedState.jointsDTO = jointsDTO
        let request = FindCharacterJointsRequest(ad_id: ad_id, jointsDTO: jointsDTO)
        
        return .run { send in
          await send(.setLoadingView(true))
          await send(
            .findCharacterJointsResponse(
              TaskResult {
                try await makeADClient.step4findCharacterJoints(request)
              }
            )
          )
        }
        
      case .findCharacterJointsResponse(.success):
        state.isSuccessFindCharacterJoints = true
        return .run { send in
          await send(.setLoadingView(false))
          await send(.toggleModifyJointsView)
        }
        
      case .findCharacterJointsResponse(.failure(let error)):
        print(error)
        let adError = error as? ADError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlert(adError))
        }
        
      case .onDismissModifyJointsView:
        if state.isSuccessFindCharacterJoints == true {
          state.sharedState.completeStep = .FindingCharacterJoints
          state.isSuccessFindCharacterJoints = false
          state.sharedState.isShowAddAnimationView = true
        }
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
