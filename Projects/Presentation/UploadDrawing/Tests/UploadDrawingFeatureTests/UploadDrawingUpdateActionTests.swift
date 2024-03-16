//
//  UploadDrawingUpdateActionTests.swift
//  UploadDrawingTests
//
//  Created by chminii on 3/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import XCTest
@testable import UploadDrawingFeatures
import DomainModels
import SharedProvider

final class UploadDrawingUpdateActionTests: XCTestCase {
  var store: TestStoreOf<UploadDrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      UploadDrawingFeature()
    }
  }
  
  func testGetIsShowStepBar() async {
    let isShow = false
    
    await store.send(.update(.getIsShowStepBar(isShow))) {
      $0.step.isShowStepBar = isShow
    }
  }
  
  func testGetCompleteStep() async {
    let step: MakeADStep = .SeparatingCharacter
    
    await store.send(.update(.getCompleteStep(step))) {
      $0.step.completeStep = step
    }
  }
  
  func testSetIsShowStepBar() async {
    let isShow = false
    
    await store.send(.update(.setIsShowStepBar(isShow)))
    
    let resultIsShow = await StepProvider.testValue.isShowStepBar.get()
    XCTAssertEqual(resultIsShow, isShow)
  }
}
