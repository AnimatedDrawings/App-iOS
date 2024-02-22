//
//  UploadADrawingViewActionTests.swift
//  UploadADrawingTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadADrawingFeatures
import ThirdPartyLib

@MainActor
final class UploadADrawingViewActionTests: XCTestCase {
  var state: UploadADrawingFeature.State!
  var store: TestStoreOf<UploadADrawingFeature>!
  
  override func setUp() async throws {
    state = UploadADrawingFeature.State()
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
  }
  
  func testCheck() async {
    await store.send(.view(.check(.list1))) {
      $0.checkState.check1 = !$0.checkState.check1
    }
    
    await store.send(.view(.check(.list2))) {
      $0.checkState.check2 = !$0.checkState.check2
    }
    
    await store.send(.view(.check(.list4))) {
      $0.checkState.check4 = !$0.checkState.check4
    }
    
    await store.send(.view(.check(.list3))) {
      $0.checkState.check3 = !$0.checkState.check3
      $0.isActiveUploadButton = true
    }
  }
  
  func testUploadDrawing() async {
    let imageData = Data()
    
    await store.send(.view(.uploadDrawing(imageData)))
    await store.receive(.async(.uploadDrawing(imageData)))
  }
  
  func testInitState() async {
    state = UploadADrawingFeature.State(isEnableUploadButton: true)
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.view(.initState)) {
      $0 = UploadADrawingFeature.State()
    }
  }
}
