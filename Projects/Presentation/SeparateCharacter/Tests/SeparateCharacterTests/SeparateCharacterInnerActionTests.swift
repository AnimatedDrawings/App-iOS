//
//  SeparateCharacterInnerActionTests.swift
//  SeparateCharacterTests
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import XCTest
@testable import SeparateCharacterFeatures

class SeparateCharacterInnerActionTests: XCTestCase {
  var store: TestStoreOf<SeparateCharacterFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      SeparateCharacterFeature()
    }
  }
  
  func testNoMaskImageErrorAlert() async {
    await store.send(.inner(.noMaskImageErrorAlert)) {
      $0.alert.noMaskImage = !$0.alert.noMaskImage
    }
  }
  
  func testPopMaskImageView() async {
    await store.send(.inner(.popMaskImageView)) {
      $0.maskImageView = !$0.maskImageView
    }
  }
  
  func testSetLoadingView() async {
    let isShow = true
    
    await store.send(.inner(.setLoadingView(isShow))) {
      $0.loadingView = isShow
    }
  }
}
