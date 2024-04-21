//
//  ConfigureAnimationInnerActionTests.swift
//  ConfigureAnimationTests
//
//  Created by chminii on 4/18/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import ConfigureAnimationFeatures

final class ConfigureAnimationInnerActionTests: XCTestCase {
  var store: TestStoreOf<ConfigureAnimationFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  }
  
  func testAlertNoAnimationFile() async {
    await store.send(.inner(.alertNoAnimationFile)) {
      $0.share.alertNoAnimation = !$0.share.alertNoAnimation
    }
  }
  
  func testAlertSaveGifResult() async {
    let isSuccess = true
    
    await store.send(.inner(.alertSaveGifResult(isSuccess))) {
      $0.share.saveResult.isSuccess = isSuccess
      $0.share.saveResult.alert = !$0.share.saveResult.alert
    }
  }
  
  func testAlertNetworkError() async {
    await store.send(.inner(.alertNetworkError)) {
      $0.configure.networkError = !$0.configure.networkError
    }
  }
  
  func testSheetShareFile() async {
    await store.send(.inner(.sheetShareFile)) {
      $0.share.sheetShareFile = !$0.share.sheetShareFile
    }
  }
  
  func testSetLoadingView() async {
    let isShow = true
    
    await store.send(.inner(.setLoadingView(isShow))) {
      $0.configure.loadingView = isShow
    }
  }
  
  func testPopAnimationListView() async {
    await store.send(.inner(.popAnimationListView)) {
      $0.configure.animationListView = !$0.configure.animationListView
    }
  }
  
  func testSetViewNeworkFail() async {
    let state = ConfigureAnimationFeature.State(
      configure: .init(selectedAnimation: .zombie)
    )
    store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.inner(.setViewNeworkFail)) {
      $0.configure.selectedAnimation = nil
    }
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.alertNetworkError))
  }
}
