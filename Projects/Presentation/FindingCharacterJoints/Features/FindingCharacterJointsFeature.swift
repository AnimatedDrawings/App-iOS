//
//  FindingCharacterJointsFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import DomainModel
import SharedProvider
import NetworkProvider

public struct FindingCharacterJointsFeature: Reducer {
  public init() {}
  
  @Dependency(\.makeADProvider) var makeADProvider
  @Dependency(\.shared.makeAD) var makeAD
  @Dependency(\.shared.stepBar) var stepBar
  @Dependency(\.shared.adViewCase) var adViewCase
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    MainReducer()
      .ifLet(\.$alertShared, action: /Action.alertShared)
  }
}

public extension FindingCharacterJointsFeature {
  struct State: Equatable {
    @BindingState public var checkState: Bool
    @BindingState public var isShowModifyJointsView: Bool
    public var isShowLoadingView: Bool
    var isSuccessFindCharacterJoints: Bool
    
    @PresentationState public var alertShared: AlertState<AlertShared>?
    
    public init(
      checkState: Bool = false,
      isShowModifyJointsView: Bool = false,
      isShowLoadingView: Bool = false,
      isSuccessFindCharacterJoints: Bool = false,
      alertShared: AlertState<AlertShared>? = nil
    ) {
      self.checkState = checkState
      self.isShowModifyJointsView = isShowModifyJointsView
      self.isShowLoadingView = isShowLoadingView
      self.isSuccessFindCharacterJoints = isSuccessFindCharacterJoints
      self.alertShared = alertShared
    }
  }
}

public extension FindingCharacterJointsFeature {
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case checkAction
    case toggleModifyJointsView
    
    case setLoadingView(Bool)
    case findCharacterJoints(Joints)
    case findCharacterJointsResponse(TaskEmptyResult)
    case onDismissModifyJointsView
    
    case showAlertShared(AlertState<AlertShared>)
    case alertShared(PresentationAction<AlertShared>)
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
        
      case .findCharacterJoints(let joints):
        return .run { send in
          guard let ad_id = await makeAD.ad_id.get() else {
            return
          }
          
          await makeAD.joints.set(joints)
          await send(.setLoadingView(true))
          await send(
            .findCharacterJointsResponse(
              TaskResult.empty {
                try await makeADProvider.findCharacterJoints(ad_id, joints)
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
//        let adMoyaError = error as? ADMoyaError ?? .connection
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showAlertShared(Self.initAlertNetworkError()))
        }
        
      case .onDismissModifyJointsView:
        if state.isSuccessFindCharacterJoints == true {
          state.isSuccessFindCharacterJoints = false
          return .run { _ in
            await stepBar.completeStep.set(.FindingCharacterJoints)
            await adViewCase.set(.ConfigureAnimation)
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

public extension FindingCharacterJointsFeature {
  enum AlertShared: Equatable {}
  
  static func initAlertNetworkError() -> AlertState<AlertShared> {
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
