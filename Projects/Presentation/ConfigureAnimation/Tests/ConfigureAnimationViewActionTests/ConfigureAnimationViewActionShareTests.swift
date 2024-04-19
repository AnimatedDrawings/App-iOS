//
//  ConfigureAnimationViewActionShareTests.swift
//  ConfigureAnimationTests
//
//  Created by chminii on 4/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import ConfigureAnimationFeatures

final class ConfigureAnimationViewActionShareTests: XCTestCase {
  var store: TestStoreOf<ConfigureAnimationFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  }
  
  func testShowShareSheetWhenCurrentAnimationNil() async {
    await store.send(.view(.share(.showShareSheet)))
    
    store.exhaustivity = .off
    await store.receive(.inner(.alertNoAnimationFile))
  }
  
  func testShowShareSheetWhenCurrentAnimationNotNil() async {
    let state = ConfigureAnimationFeature.State(currentAnimation: .init())
    store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.view(.share(.showShareSheet))) {
      $0.share.sheetShare = !$0.share.sheetShare
    }
  }
  
  func testShareSheetActions_save() async {
    let currentAnimation: ConfigureAnimationFeature.ADAnimationFile = .init()
    let state = ConfigureAnimationFeature.State(currentAnimation: currentAnimation)
    store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.view(.share(.shareSheetActions(.save))))
    
    store.exhaustivity = .off
    await store.receive(.async(.saveGifInPhotos(currentAnimation.url)))
  }
  
  func testShareSheetActions_share() async {
    let currentAnimation: ConfigureAnimationFeature.ADAnimationFile = .init()
    let state = ConfigureAnimationFeature.State(currentAnimation: currentAnimation)
    store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.view(.share(.shareSheetActions(.share))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.sheetShareFile))
  }
}
