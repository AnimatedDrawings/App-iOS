//
//  RootState.swift
//  RootFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import MakeADFeatures
import ConfigureAnimationFeatures
import DomainModels

public extension RootFeature {
  @ObservableState
  struct State: Equatable {
    public var adViewState: ADViewState
    public var makeAD: MakeADFeature.State
    public var configureAnimation: ConfigureAnimationFeature.State
    
    public init(
      adViewState: ADViewState = .OnBoarding,
      makeAD: MakeADFeature.State = .init(),
      configureAnimation: ConfigureAnimationFeature.State = .init()
    ) {
      self.adViewState = adViewState
      self.makeAD = makeAD
      self.configureAnimation = configureAnimation
    }
  }
}
