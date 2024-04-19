//
//  ConfigureAnimationViewActionFixTests.swift
//  ConfigureAnimationTests
//
//  Created by chminii on 4/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import ConfigureAnimationFeatures
import SharedProvider

final class ConfigureAnimationViewActionFixTests: XCTestCase {
  var store: TestStoreOf<ConfigureAnimationFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  }
  
  func testFix() async {
    let adViewStateProvider = ADViewStateProvider.init(currentView: .ConfigureAnimation)
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
        .dependency(adViewStateProvider)
    }
    
    await store.send(.view(.fix))
    
    let currentView = await adViewStateProvider.adViewState.get()
    XCTAssertEqual(currentView, .MakeAD)
  }
}
