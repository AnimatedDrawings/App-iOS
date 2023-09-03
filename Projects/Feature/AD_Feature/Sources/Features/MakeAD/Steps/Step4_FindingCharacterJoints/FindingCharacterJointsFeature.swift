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
    
//    @BindingState public var checkState = false
    public var checkState = false
    @BindingState public var isShowModifyJointsView = false
    public var isShowLoadingView = false
    var isSuccessFindCharacterJoints = false
    
    @PresentationState public var alertShared: AlertState<AlertShared>? = nil
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
    
    case showAlertShared(AlertState<AlertShared>)
    case alertShared(PresentationAction<AlertShared>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
      .ifLet(\.$alertShared, action: /Action.alertShared)
  }
}

extension FindingCharacterJointsFeature {
  func MainReducer() -> some Reducer<State, Action> {
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
        state.isSuccessFindCharacterJoints = false
        let adMoyaError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlertShared(initAlertNetworkError()))
        }
        
      case .onDismissModifyJointsView:
        if state.isSuccessFindCharacterJoints == true {
          state.sharedState.completeStep = .FindingCharacterJoints
          state.isSuccessFindCharacterJoints = false
          state.sharedState.isShowConfigureAnimationView = true
        }
        return .none
        
      case .alertShared:
        return .none
      case .showAlertShared(let alertState):
        state.alertShared = alertState
        return .none
      }
    }
  }
}

extension FindingCharacterJointsFeature {
  public enum AlertShared: Equatable {}
  
  func initAlertNetworkError() -> AlertState<AlertShared> {
    return AlertState(
      title: {
        TextState("Connection Error")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState("Please check device network condition.")
      }
    )
  }
}


//extension ADMoyaError {
//  func alertState<S: ADAlertState>() -> AlertState<S> {
//    let title: String
//    let message: String
//
//    switch self {
//    case .jsonMapping, .connection:
//      title = "Connection Error"
//      message = "Please check device network condition."
//    default:
//      title = "Animating Error"
//      message = "Cannot caculate Animated Drawings. Proceed Step Manually."
//    }
//
//    return AlertState(
//      title: {
//        TextState(title)
//      },
//      actions: {
//        ButtonState(role: .cancel) {
//          TextState("cancel")
//        }
//      },
//      message: {
//        TextState(message)
//      }
//    )
//  }
//}
