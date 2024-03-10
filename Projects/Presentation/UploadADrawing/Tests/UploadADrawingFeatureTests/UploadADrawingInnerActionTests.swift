//
//  UploadADrawingInnerActionTests.swift
//  UploadADrawingTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadADrawingFeatures
import ThirdPartyLib
import DomainModel

final class UploadADrawingInnerActionTests: XCTestCase {
  var state: UploadADrawingFeature.State!
  var store: TestStoreOf<UploadADrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    state = UploadADrawingFeature.State()
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
  }
  
  func testSetLoadingView() async {
    await store.send(.inner(.setLoadingView(true))) {
      $0.loadingView = true
    }
  }
  
  func testShowNetworkErrorAlert() async {
    let isShow = true
    state = UploadADrawingFeature.State(alert: .init(networkError: isShow))
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.inner(.showNetworkErrorAlert)) {
      $0.alert.networkError = !isShow
    }
  }
  
  func testShowFindCharacterErrorAlert() async {
    let isShow = true
    state = UploadADrawingFeature.State(alert: .init(findCharacterError: isShow))
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.inner(.showFindCharacterErrorAlert)) {
      $0.alert.findCharacterError = !isShow
    }
  }
  
  func testShowImageSizeErrorAlert() async {
    let isShow = true
    state = UploadADrawingFeature.State(alert: .init(imageSizeError: isShow))
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.inner(.showImageSizeErrorAlert)) {
      $0.alert.imageSizeError = !isShow
    }
  }
}
