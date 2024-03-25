//
//  ADViewProvider.swift
//  SharedProvider
//
//  Created by chminii on 2/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import DomainModels
import ADComposableArchitecture

public struct ADViewProvider {
  public var currentView: GlobalNotifier<ADViewCase>
  
  public init(currentView: ADViewCase = .OnBoarding) {
    self.currentView = GlobalNotifier(initialValue: currentView)
  }
}

extension ADViewProvider: DependencyKey {
  public static var liveValue = ADViewProvider()
  public static var testValue = ADViewProvider()
}

public extension DependencyValues {
  var adViewState: ADViewProvider {
    get { self[ADViewProvider.self] }
    set { self[ADViewProvider.self] = newValue }
  }
}
