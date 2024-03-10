//
//  UploadADrawingUpdateActionTests.swift
//  UploadADrawingTests
//
//  Created by chminii on 3/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import XCTest
@testable import UploadADrawingFeatures
import DomainModel
import SharedProvider

final class UploadADrawingUpdateActionTests: XCTestCase {
  var state: UploadADrawingFeature.State!
  var store: TestStoreOf<UploadADrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    state = UploadADrawingFeature.State()
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    } withDependencies: {
      $0.makeADProvider = .testValue
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
