//
//  FindingTheCharacterUpdateActionTests.swift
//  FindingTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindingTheCharacterFeatures
import ADComposableArchitecture
import DomainModel
import SharedProvider

final class FindingTheCharacterUpdateActionTests: XCTestCase {
  var store: TestStoreOf<FindingTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      FindingTheCharacterFeature()
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
    XCTAssertEqual(isShow, resultIsShow)
  }
}
