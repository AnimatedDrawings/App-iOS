//
//  FindingTheCharacterInnerActionTests.swift
//  FindingTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindingTheCharacterFeatures
import ThirdPartyLib

final class FindingTheCharacterInnerActionTests: XCTestCase {
  var state: FindingTheCharacterFeature.State!
  var store: TestStoreOf<FindingTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    state = FindingTheCharacterFeature.State()
    store = TestStore(initialState: .init()) {
      FindingTheCharacterFeature()
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
}
