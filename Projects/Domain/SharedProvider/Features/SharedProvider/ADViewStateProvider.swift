//
//  ADViewStateProvider.swift
//  SharedProvider
//
//  Created by chminii on 2/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import DomainModels
import ADComposableArchitecture

public struct ADViewStateProvider {
  public var adViewState: GlobalNotifier<ADViewState>
  
  public init(currentView: ADViewState = .OnBoarding) {
    self.adViewState = GlobalNotifier(initialValue: currentView)
  }
}

extension ADViewStateProvider: DependencyKey {
  public static var liveValue = ADViewStateProvider()
  public static var testValue = ADViewStateProvider()
}

public extension DependencyValues {
  var adViewState: ADViewStateProvider {
    get { self[ADViewStateProvider.self] }
    set { self[ADViewStateProvider.self] = newValue }
  }
}
