//
//  ConfigureAnimationViewActionConfigureTests.swift
//  ConfigureAnimationTests
//
//  Created by chminii on 4/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import ConfigureAnimationFeatures
import DomainModels

final class ConfigureAnimationViewActionConfigureTests: XCTestCase {
  var store: TestStoreOf<ConfigureAnimationFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  }
  
  func testPushAnimationListView() async {
    await store.send(.view(.configure(.pushAnimationListView))) {
      $0.configure.animationListView = !$0.configure.animationListView
    }
  }
  
  func testSelectAnimationItem() async {
    let animation: ADAnimation = .zombie
    await store.send(.view(.configure(.selectAnimationItem(animation))))
    
    store.exhaustivity = .off
    await store.receive(.async(.startRendering(animation)))
  }
}
