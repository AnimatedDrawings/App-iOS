//
//  ADViewState.swift
//  SharedProvider
//
//  Created by chminii on 2/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import SharedStorage
import DomainModel
import ThirdPartyLib

public struct ADViewState {
  public var currentView: CombineNotifier<ADViewCase>
  
  public init(currentView: ADViewCase = .OnBoarding) {
    self.currentView = CombineNotifier(initialValue: currentView)
  }
}

extension ADViewState: DependencyKey {
  public static var liveValue = ADViewState()
  public static var testValue = ADViewState()
}

public extension DependencyValues {
  var adViewState: ADViewState {
    get { self[ADViewState.self] }
    set { self[ADViewState.self] = newValue }
  }
}
