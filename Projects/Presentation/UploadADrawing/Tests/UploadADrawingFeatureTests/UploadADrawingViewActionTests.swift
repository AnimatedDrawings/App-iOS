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
import SharedProvider

final class UploadADrawingViewActionTests: XCTestCase {
  var store: TestStoreOf<UploadADrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      UploadADrawingFeature()
    }
  }
  
  func testTask() async {
    let isShow = await StepProvider.testValue.isShowStepBar.get()
    let completeStep = await StepProvider.testValue.completeStep.get()
    
    store.exhaustivity = .off
    
    await store.send(.view(.task))
    await store.receive(.update(.getIsShowStepBar(isShow)))
    await store.receive(.update(.getCompleteStep(completeStep)))
  }
  
  func testCheck() async {
    let show = true
    await store.send(.view(.check(.list1(show)))) {
      $0.check.list1 = !$0.check.list1
    }
    
    await store.send(.view(.check(.list2(show)))) {
      $0.check.list2 = !$0.check.list2
    }
    
    await store.send(.view(.check(.list4(show)))) {
      $0.check.list4 = !$0.check.list4
    }
    
    await store.send(.view(.check(.list3(show)))) {
      $0.check.list3 = !$0.check.list3
      $0.uploadButton = show
    }
  }
  
  func testUploadDrawing() async {
    let imageData = Data()
    
    store.exhaustivity = .off
    await store.send(.view(.uploadDrawing(imageData)))
    await store.receive(.async(.uploadDrawing(imageData)))
  }
}
