//
//  SharedValue.swift
//  SharedProvider
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import SwiftUI
import Combine
import SharedStorage

@propertyWrapper
public struct SharedValue<Output: Equatable>: DynamicProperty {
  public var wrappedValue: Output {
    get {
      storage.value
    }
    nonmutating set {
      storage.value = newValue
    }
  }
  
  @StateObject private var storage: SharedObservable<Output>
  
  public var projectedValue: Binding<Output> {
    Binding<Output>(
      get: { wrappedValue },
      set: { wrappedValue = $0 }
    )
  }
  
  public init(
    _ keyPath: KeyPath<DependencyValues, CombineNotifier<Output>>
  ) {
    let notifier = DependencyValues._current[keyPath: keyPath]
    self._storage = StateObject(
      wrappedValue: SharedObservable(notifier: notifier)
    )
  }
  
  public init(
    _ inject: CombineNotifier<Output>
  ) {
    self._storage = StateObject(
      wrappedValue: SharedObservable(notifier: inject)
    )
  }
}
