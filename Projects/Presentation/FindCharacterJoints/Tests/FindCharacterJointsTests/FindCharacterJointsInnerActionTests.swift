//
//  FindCharacterJointsInnerActionTests.swift
//  FindCharacterJointsTests
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindCharacterJointsFeatures
import ADComposableArchitecture

final class FindCharacterJointsInnerActionTests: XCTestCase {
  var store: TestStoreOf<FindCharacterJointsFeature>!
  
  override func setUp() {
    let state: FindCharacterJointsFeature.State = .init()
    store = TestStore(initialState: state) {
      FindCharacterJointsFeature()
    }
  }
  
  func testSetLoadingView() async {
    let isShow = true
    
    await store.send(.inner(.setLoadingView(true))) {
      $0.loadingView = isShow
    }
  }
  
  func testPopModifyJointsView() async {
    await store.send(.inner(.popModifyJointsView)) {
      $0.modifyJointsView = !$0.modifyJointsView
    }
  }
  
  func testNetworkErrorAlert() async {
    await store.send(.inner(.networkErrorAlert)) {
      $0.alert.networkError = !$0.alert.networkError
    }
  }
}
