//
//  UploadADrawingInnerActionTests.swift
//  UploadADrawingTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadADrawingFeatures
import ADComposableArchitecture
import DomainModel

final class UploadADrawingInnerActionTests: XCTestCase {
  var store: TestStoreOf<UploadADrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      UploadADrawingFeature()
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
