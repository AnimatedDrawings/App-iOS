//
//  FindingCharacterJointsFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import MoyaProvider
import Domain_Model
import SharedProvider

public struct FindingCharacterJointsFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADClient) var makeADClient
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  
  public struct State: Equatable {
    public init() {}
    
    public var checkState = false
    @BindingState public var isShowModifyJointsView = false
    public var isShowLoadingView = false
    var isSuccessFindCharacterJoints = false
    
    @PresentationState public var alertShared: AlertState<AlertShared>? = nil
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    
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
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else {
            return
          }

          let request = FindCharacterJointsRequest(ad_id: ad_id, jointsDTO: jointsDTO)
          
          await makeAD.jointsDTO.set(jointsDTO)
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
          state.isSuccessFindCharacterJoints = false
          return .run { _ in
            await stepBar.completeStep.set(.FindingCharacterJoints)
            await makeAD.isShowConfigureAnimationView.set(true)
          }
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
