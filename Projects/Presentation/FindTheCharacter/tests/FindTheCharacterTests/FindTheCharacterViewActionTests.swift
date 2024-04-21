//
//  FindTheCharacterViewActionTests.swift
//  FindTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindTheCharacterFeatures
@testable import CropImageFeatures
import ADComposableArchitecture
import SharedProvider

final class FindTheCharacterViewActionTests: XCTestCase {
  var store: TestStoreOf<FindTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      FindTheCharacterFeature()
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
  
  func testCheckList() async {
    let checkState = true
    
    await store.send(.view(.checkList(checkState))) {
      $0.checkList = checkState
    }
  }
  
  func testPushCropImageViewAlertNoCropImageError() async {
    await store.send(.view(.showCropImageView))
    
    store.exhaustivity = .off
    await store.receive(.inner(.noCropImageErrorAlert))
  }
  
  func testPushCropImageViewNoAlert() async {
    let cropImageState = CropImageFeature.State.mock()
    let state = FindTheCharacterFeature.State(cropImage: cropImageState)
    store = TestStore(initialState: state) {
      FindTheCharacterFeature()
    }
    
    await store.send(.view(.showCropImageView)) {
      $0.cropImageView = !$0.cropImageView
    }
  }
}
