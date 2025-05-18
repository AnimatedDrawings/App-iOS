//
//  ConfigureAnimationConfigureState.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels

extension ConfigureAnimationFeature {
  @ObservableState
  public struct Configure: Equatable {
    public var loadingDescription: String
    public var loadingView: Bool
    public var animationListView: Bool
    public var networkError: Bool
    public var fullJob: Bool
    public var alertStartRendering: Bool
    public var selectedAnimation: ADAnimation?

    public init(
      loadingDescription: String = "Make Animation ...",
      loadingView: Bool = false,
      animationListView: Bool = false,
      networkError: Bool = false,
      fullJob: Bool = false,
      alertStartRendering: Bool = false,
      selectedAnimation: ADAnimation? = nil
    ) {
      self.loadingDescription = loadingDescription
      self.loadingView = loadingView
      self.animationListView = animationListView
      self.networkError = networkError
      self.fullJob = fullJob
      self.alertStartRendering = alertStartRendering
      self.selectedAnimation = selectedAnimation
    }
  }
}
