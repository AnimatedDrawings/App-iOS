//
//  FindingTheCharacterViewActionTests.swift
//  FindingTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindingTheCharacterFeatures
@testable import CropImageFeatures
import ThirdPartyLib
import SharedProvider

final class FindingTheCharacterViewActionTests: XCTestCase {
  var store: TestStoreOf<FindingTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      FindingTheCharacterFeature()
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
  
  func testToggleCropImageViewAlertNoCropImageError() async {
    await store.send(.view(.toggleCropImageView))
    
    store.exhaustivity = .off
    await store.receive(.inner(.noCropImageErrorAlert))
  }
  
  func testToggleCropImageViewNoAlert() async {
    let cropImageState = CropImageFeature.State.mock()
    let state = FindingTheCharacterFeature.State(cropImage: cropImageState)
    store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    await store.send(.view(.toggleCropImageView)) {
      $0.cropImageView = !$0.cropImageView
    }
  }
}
