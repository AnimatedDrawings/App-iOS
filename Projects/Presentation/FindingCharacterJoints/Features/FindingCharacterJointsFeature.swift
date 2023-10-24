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
  }
}

public extension FindingCharacterJointsFeature {
  struct State: Equatable {
    @BindingState public var checkState: Bool
    @BindingState public var isShowModifyJointsView: Bool
    public var isShowLoadingView: Bool
    var isSuccessFindCharacterJoints: Bool
    
    @BindingState public var isShowNetworkErrorAlert: Bool
    
    public init(
      checkState: Bool = false,
      isShowModifyJointsView: Bool = false,
      isShowLoadingView: Bool = false,
      isSuccessFindCharacterJoints: Bool = false,
      isShowNetworkErrorAlert: Bool = false
    ) {
      self.checkState = checkState
      self.isShowModifyJointsView = isShowModifyJointsView
      self.isShowLoadingView = isShowLoadingView
      self.isSuccessFindCharacterJoints = isSuccessFindCharacterJoints
      self.isShowNetworkErrorAlert = isShowNetworkErrorAlert
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
    
    case showNetworkErrorAlert
    
    case initState
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
        return .run { send in
          await send(.setLoadingView(false))
          await send(.showNetworkErrorAlert)
        }
        
      case .onDismissModifyJointsView:
        if state.isSuccessFindCharacterJoints == true {
          state.isSuccessFindCharacterJoints = false
          return .run { _ in
            await adViewCase.set(.ConfigureAnimation)
            await stepBar.completeStep.set(.FindingCharacterJoints)
          }
        }
        return .none
        
      case .showNetworkErrorAlert:
        state.isShowNetworkErrorAlert.toggle()
        return .none
        
      case .initState:
        state = State()
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
