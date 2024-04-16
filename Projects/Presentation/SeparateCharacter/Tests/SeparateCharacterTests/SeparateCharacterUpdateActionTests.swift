//
//  SeparateCharacterUpdateActionTests.swift
//  SeparateCharacterTests
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import SeparateCharacterFeatures
import DomainModels
import SharedProvider

class SeparateCharacterUpdateActionTests: XCTestCase {
  var store: TestStoreOf<SeparateCharacterFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      SeparateCharacterFeature()
    }
  }
  
  func testGetIsShowStepBar() async {
    let isShow = false
    
    await store.send(.update(.getIsShowStepBar(isShow))) {
      $0.step.isShowStepBar = isShow
    }
  }
  
  func testGetCompleteStep() async {
    let step: MakeADStep = .SeparatCharacter
    
    await store.send(.update(.getCompleteStep(step))) {
      $0.step.completeStep = step
    }
  }
  
  func testSetIsShowStepBar() async {
    let isShow = false
    
    await store.send(.update(.setIsShowStepBar(isShow)))
    
    let resultIsShow = await StepProvider.testValue.isShowStepBar.get()
    XCTAssertEqual(isShow, resultIsShow)
  }
}
