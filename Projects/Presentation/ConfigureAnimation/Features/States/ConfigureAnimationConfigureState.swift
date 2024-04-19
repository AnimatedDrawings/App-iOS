//
//  ConfigureAnimationConfigureState.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels

public extension ConfigureAnimationFeature {
  @ObservableState
  struct Configure: Equatable {
    public var animationListView: Bool
    public var loadingView: Bool
    public var networkError: Bool
    public var selectedAnimation: ADAnimation?
    
    public init(
      animationListView: Bool = false,
      loadingView: Bool = false,
      networkError: Bool = false,
      selectedAnimation: ADAnimation? = nil
    ) {
      self.animationListView = animationListView
      self.loadingView = loadingView
      self.networkError = networkError
      self.selectedAnimation = selectedAnimation
    }
  }
}
