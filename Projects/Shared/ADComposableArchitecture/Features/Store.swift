//
//  Store.swift
//  ADComposableArchitecture
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ComposableArchitecture

public extension ViewStore {
  func action(_ action: ViewAction) -> (() -> Void) {
    return { self.send(action) }
  }
}

public extension Store {
  func action(_ action: Action) -> (() -> Void) {
    return { self.send(action) }
  }
}
