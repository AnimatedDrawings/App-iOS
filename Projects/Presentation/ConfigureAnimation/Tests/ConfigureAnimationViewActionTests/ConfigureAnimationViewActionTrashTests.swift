//
//  ConfigureAnimationViewActionTrashTests.swift
//  ConfigureAnimationTests
//
//  Created by chminii on 4/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import ConfigureAnimationFeatures

final class ConfigureAnimationViewActionTrashTests: XCTestCase {
  var store: TestStoreOf<ConfigureAnimationFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  }
  
  func testShowAlert() async {
    await store.send(.view(.trash(.showAlert))) {
      $0.trash.alert = !$0.trash.alert
    }
  }
  
  func testTrashAlertActions_confirm() async {
    await store.send(.view(.trash(.trashAlertActions(.confirm))))
    
    store.exhaustivity = .off
    await store.receive(.delegate(.resetMakeAD))
  }
}
