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
  public var current: CombineNotifier<ADViewCase>
  
  public init(current: ADViewCase = .OnBoarding) {
    self.current = CombineNotifier(initialValue: current)
  }
}

extension ADViewState: DependencyKey {
  public static var liveValue = ADViewState()
  public static func testValue(current: ADViewCase) -> ADViewState {
    ADViewState(current: current)
  }
  public static func previewValue(current: ADViewCase) -> ADViewState {
    ADViewState(current: current)
  }
}

public extension DependencyValues {
  var adView: ADViewState {
    get { self[ADViewState.self] }
    set { self[ADViewState.self] = newValue }
  }
}
