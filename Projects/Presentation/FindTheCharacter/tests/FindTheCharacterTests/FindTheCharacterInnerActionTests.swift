//
//  FindTheCharacterInnerActionTests.swift
//  FindTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindTheCharacterFeatures
import ADComposableArchitecture

final class FindTheCharacterInnerActionTests: XCTestCase {
  var store: TestStoreOf<FindTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      FindTheCharacterFeature()
    }
  }
  
  func testSetLoadingView() async {
    let isShow = true
    
    await store.send(.inner(.setLoadingView(isShow))) {
      $0.loadingView = isShow
    }
  }
  
  func testToggleCropImageView() async {
    await store.send(.inner(.toggleCropImageView)) {
      $0.cropImageView = !$0.cropImageView
    }
  }
  
  func testNetworkErrorAlert() async {
    await store.send(.inner(.networkErrorAlert)) {
      $0.alert.networkError = !$0.alert.networkError
    }
  }
  
  func testNoCropImageErrorAlert() async {
    await store.send(.inner(.noCropImageErrorAlert)) {
      $0.alert.noCropImage = !$0.alert.noCropImage
    }
  }
}
