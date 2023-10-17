//
//  SeparatingCharacterTests.swift
//  SeparatingCharacterTests
//
//  Created by minii on 2023/10/16.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import SeparatingCharacterFeatures
import ThirdPartyLib
import SharedProvider
import ADUIKit
import NetworkProvider
import DomainModel

@MainActor
final class SeparatingCharacterTests: XCTestCase {
  enum MockError: Error {
    case mock
  }
  
  func testCheckAction() async {
    let state = SeparatingCharacterFeature.State()
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    await store.send(.checkAction1) {
      $0.checkState1 = !$0.checkState1
    }
    await store.send(.checkAction2) {
      $0.checkState2 = !$0.checkState2
      $0.isActiveMaskingImageButton = true
    }
  }
  
  func testToggleMaskingImageView() async {
    let state = SeparatingCharacterFeature.State()
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    await store.send(.toggleMaskingImageView) {
      $0.isShowMaskingImageView = !$0.isShowMaskingImageView
    }
  }
  
  func testSetLoadingView() async {
    let state = SeparatingCharacterFeature.State()
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    await store.send(.setLoadingView(true)) {
      $0.isShowLoadingView = true
    }
  }
  
  func testMaskNextAction() async {
    let testMakeADStorage = Shared.testValue.makeAD
    let mockADID = "testMaskNextAction"
    await testMakeADStorage.ad_id.set(mockADID)
    let mockMaskedImage: UIImage = ADUIKitAsset.SampleDrawing.step1Example1.image
    await testMakeADStorage.maskedImage.set(mockMaskedImage)
    
    let testSeparateCharacter = MakeADProvider.testValue.separateCharacter
    
    let state = SeparatingCharacterFeature.State()
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.maskNextAction(true))
    guard let testADID = await testMakeADStorage.ad_id.get(),
          let testMaskedImage = await testMakeADStorage.maskedImage.get(),
          let testMaskedImageData = testMaskedImage.pngData()
    else {
      XCTFail()
      return
    }
    XCTAssertEqual(mockADID, testADID)
    XCTAssertEqual(mockMaskedImage, testMaskedImage)
    
    await store.receive(.setLoadingView(true))
    await store.receive(
      .separateCharacterResponse(
        TaskResult {
          try await testSeparateCharacter(testADID, testMaskedImageData)
        }
      )
    )
  }
  
  func testSeparateCharacterResponseSuccess() async {
    let mockJoints = Joints.mockData()!
    let testJointsStorage = Shared.testValue.makeAD.joints
    let state = SeparatingCharacterFeature.State()
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.separateCharacterResponse(.success(mockJoints))) {
      $0.isSuccessSeparateCharacter = true
    }
    guard let testJoints = await testJointsStorage.get() else {
      XCTFail()
      return
    }
    XCTAssertEqual(testJoints, mockJoints)
    await store.receive(.setLoadingView(false))
    await store.receive(.toggleMaskingImageView)
  }
  
  func testSeparateCharacterResponseFailure() async {
    let mockAlertState = SeparatingCharacterFeature.initAlertNetworkError()
    let state = SeparatingCharacterFeature.State()
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.separateCharacterResponse(.failure(MockError.mock))) {
      $0.isSuccessSeparateCharacter = false
    }
    await store.receive(.setLoadingView(false))
    await store.receive(.showAlertShared(mockAlertState))
  }
  
  func testOnDismissMakingImageView() async {
    let testStepBarStorage = Shared.testValue.stepBar
    let state = SeparatingCharacterFeature.State(
      isSuccessSeparateCharacter: true
    )
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    await store.send(.onDismissMakingImageView) {
      $0.isSuccessSeparateCharacter = false
    }
    let testCompleteStep = await testStepBarStorage.completeStep.get()
    let testCurrentStep = await testStepBarStorage.currentStep.get()
    let testIsShowStepStatusBar = await testStepBarStorage.isShowStepStatusBar.get()
    XCTAssertEqual(testCompleteStep, Step.SeparatingCharacter)
    XCTAssertEqual(testCurrentStep, Step.FindingCharacterJoints)
    XCTAssertEqual(testIsShowStepStatusBar, true)
  }
  
  func testShowAlertShared() async {
    let mockAlertState = SeparatingCharacterFeature.initAlertNetworkError()
    let state = SeparatingCharacterFeature.State()
    let store = TestStore(initialState: state) {
      SeparatingCharacterFeature()
    }
    
    await store.send(.showAlertShared(mockAlertState)) {
      $0.alertShared = mockAlertState
    }
  }
}
