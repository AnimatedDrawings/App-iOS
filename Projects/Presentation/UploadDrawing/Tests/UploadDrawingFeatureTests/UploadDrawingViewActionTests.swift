//
//  UploadDrawingViewActionTests.swift
//  UploadDrawingTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadDrawingFeatures
import ADComposableArchitecture
import SharedProvider

final class UploadDrawingViewActionTests: XCTestCase {
  var store: TestStoreOf<UploadDrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      UploadDrawingFeature()
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
      $0.check.list1 = show
    }
    
    await store.send(.view(.check(.list2(show)))) {
      $0.check.list2 = show
    }
    
    await store.send(.view(.check(.list4(show)))) {
      $0.check.list4 = show
    }
    
    await store.send(.view(.check(.list3(show)))) {
      $0.check.list3 = show
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
