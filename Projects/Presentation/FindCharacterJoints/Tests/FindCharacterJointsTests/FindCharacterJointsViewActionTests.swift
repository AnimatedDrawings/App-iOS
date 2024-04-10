//
//  FindCharacterJointsViewActionTests.swift
//  FindCharacterJointsTests
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindCharacterJointsFeatures
import ADComposableArchitecture
import SharedProvider

final class FindCharacterJointsViewActionTests: XCTestCase {
  var store: TestStoreOf<FindCharacterJointsFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      FindCharacterJointsFeature()
    }
  }
  
  func testTask() async {
    let isShow = await StepProvider.testValue.isShowStepBar.get()
    let step = await StepProvider.testValue.completeStep.get()
    
    store.exhaustivity = .off
    await store.send(.view(.task))
    
    await store.receive(.update(.getIsShowStepBar(isShow)))
    await store.receive(.update(.getCompleteStep(step)))
  }
  
  func testPushModifyJointsView() async {
    await store.send(.view(.pushModifyJointsView)) {
      $0.modifyJointsView = !$0.modifyJointsView
    }
  }
  
}
