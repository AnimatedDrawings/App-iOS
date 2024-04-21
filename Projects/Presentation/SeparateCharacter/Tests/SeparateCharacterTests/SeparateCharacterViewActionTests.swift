//
//  SeparateCharacterViewActionTests.swift
//  SeparateCharacterTests
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import SeparateCharacterFeatures
import ADComposableArchitecture
import SharedProvider
import MaskImageFeatures

final class SeparateCharacterViewActionTests: XCTestCase {
  var store: TestStoreOf<SeparateCharacterFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      SeparateCharacterFeature()
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
  
  func testCheck() async {
    let show = true
    
    await store.send(.view(.check(.list1(show)))) {
      $0.check.list1 = show
    }
    
    await store.send(.view(.check(.list2(show)))) {
      $0.check.list2 = show
      $0.maskImageButton = show
    }
  }
  
  func testPushMaskImageViewAlertNoMaskImageError() async {
    await store.send(.view(.pushMaskImageView))
    
    store.exhaustivity = .off
    await store.receive(.inner(.noMaskImageErrorAlert))
  }
  
  func testPushMaskImageViewNoAlert() async {
    let maskImageState: MaskImageFeature.State = .mock()
    let state = SeparateCharacterFeature.State(maskImage: maskImageState)
    store = TestStore(initialState: state) {
      SeparateCharacterFeature()
    }
    
    await store.send(.view(.pushMaskImageView)) {
      $0.maskImageView = !$0.maskImageView
    }
  }
}
