//
//  FindCharacterJointsState.swift
//  FindCharacterJointsFeatures
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ModifyJointsFeatures
import DomainModels

public extension FindCharacterJointsFeature {
  @ObservableState
  struct State: Equatable {
    public var step: StepState
    public var checkState: Bool
    public var modifyJointsView: Bool
    public var loadingView: Bool
    public var alert: Alert
    public var modifyJoints: ModifyJointsFeature.State?
    
    public init(
      step: StepState = .init(),
      checkState: Bool = false,
      modifyJointsView: Bool = false,
      loadingView: Bool = false,
      alert: Alert = .init(),
      modifyJoints: ModifyJointsFeature.State? = nil
    ) {
      self.step = step
      self.checkState = checkState
      self.modifyJointsView = modifyJointsView
      self.loadingView = loadingView
      self.alert = alert
      self.modifyJoints = modifyJoints
    }
  }
  
  @ObservableState
  struct Alert: Equatable {
    public var networkError: Bool
    
    public init(
      networkError: Bool = false
    ) {
      self.networkError = networkError
    }
  }
  
  @ObservableState
  struct StepState: Equatable {
    public var isShowStepBar: Bool
    public var completeStep: MakeADStep
    
    public init(
      isShowStepBar: Bool = true,
      completeStep: MakeADStep = .None
    ) {
      self.isShowStepBar = isShowStepBar
      self.completeStep = completeStep
    }
  }
}
