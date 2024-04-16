//
//  FindCharacterJointsUpdateActionTests.swift
//  FindCharacterJointsTests
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindCharacterJointsFeatures
import ADComposableArchitecture
import DomainModels
import SharedProvider

final class FindCharacterJointsUpdateActionTests: XCTestCase {
  var store: TestStoreOf<FindCharacterJointsFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      FindCharacterJointsFeature()
    }
  }
  
  func testGetIsShowStepBar() async {
    let isShow = false
    
    await store.send(.update(.getIsShowStepBar(isShow))) {
      $0.step.isShowStepBar = isShow
    }
  }
  
  func testGetCompleteStep() async {
    let step: MakeADStep = .SeparateCharacter
    
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
