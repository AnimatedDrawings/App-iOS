//
//  UploadDrawingInnerActionTests.swift
//  UploadDrawingTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadDrawingFeatures
import ADComposableArchitecture

final class UploadDrawingInnerActionTests: XCTestCase {
  var store: TestStoreOf<UploadDrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      UploadDrawingFeature()
    }
  }
  
  func testSetLoadingView() async {
    await store.send(.inner(.setLoadingView(true))) {
      $0.loadingView = true
    }
  }
  
  func testShowNetworkErrorAlert() async {
    await store.send(.inner(.showNetworkErrorAlert)) {
      $0.alert.networkError = !$0.alert.networkError
    }
  }
  
  func testShowFindCharacterErrorAlert() async {
    await store.send(.inner(.showFindCharacterErrorAlert)) {
      $0.alert.findCharacterError = !$0.alert.findCharacterError
    }
  }
  
  func testShowImageSizeErrorAlert() async {
    await store.send(.inner(.showImageSizeErrorAlert)) {
      $0.alert.imageSizeError = !$0.alert.imageSizeError
    }
  }
}
