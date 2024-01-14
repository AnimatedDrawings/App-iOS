//
//  FindingTheCharacterTests.swift
//  FindingTheCharacterTests
//
//  Created by minii on 2023/10/16.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import FindingTheCharacterFeatures
import ThirdPartyLib
import SharedProvider
import NetworkProvider
import DomainModel
import ADUIKitResources

@MainActor
final class FindingTheCharacterTests: XCTestCase {
  enum MockError: Error {
    case mock
  }
  
  func testCheckAction() async {
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    await store.send(.checkAction) {
      $0.checkState = !$0.checkState
    }
  }
  
  func testToggleCropImageView() async {
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    await store.send(.toggleCropImageView) {
      $0.isShowCropImageView = !$0.isShowCropImageView
    }
  }
  
  func testSetLoadingView() async {
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    await store.send(.setLoadingView(true)) {
      $0.isShowLoadingView = true
    }    
  }
  
  func testFindTheCharacter() async {
    let mockCroppedUIImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
    let mockBoundingBox = CGRect(x: 1, y: 1, width: 1, height: 1)
    let testCroppedImageStorage = Shared.testValue.makeAD.croppedImage
    let testBoundingBoxStorage = Shared.testValue.makeAD.boundingBox
    
    let testADIDStorage = Shared.testValue.makeAD.ad_id
    let mockADID = "testFindTheCharacter"
    await testADIDStorage.set(mockADID)
    
    let testFindTheCharacter = MakeADProvider.testValue.findTheCharacter
    
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.findTheCharacter(mockCroppedUIImage, mockBoundingBox))
    let testBoundingBox = await testBoundingBoxStorage.get()
    let testCroppedImage = await testCroppedImageStorage.get()
    XCTAssertEqual(testBoundingBox, mockBoundingBox)
    XCTAssertEqual(testCroppedImage, mockCroppedUIImage)
    await store.receive(.setLoadingView(true))
    await store.receive(
      .findTheCharacterResponse(
        TaskResult.empty {
          try await testFindTheCharacter(mockADID, mockBoundingBox)
        }
      )
    )
  }
  
  func testFindTheCharacterResponseSuccess() async {
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.findTheCharacterResponse(.success(TaskEmptyResultValue())))
    await store.receive(.downloadMaskImage)
  }
  
  func testFindTheCharacterResponseFailure() async {
    let state = FindingTheCharacterFeature.State(
      isSuccessUpload: true
    )
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.findTheCharacterResponse(.failure(MockError.mock))) {
      $0.isSuccessUpload = false
    }
    await store.receive(.setLoadingView(false))
    await store.receive(.showNetworkErrorAlert)
  }
  
  func testDownloadMaskImage() async {
    let mockADID = "testDownloadMaskImage"
    let testADIDStorage = Shared.testValue.makeAD.ad_id
    await testADIDStorage.set(mockADID)
    
    let testDownloadMaskImage = MakeADProvider.testValue.downloadMaskImage
    
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.downloadMaskImage)
    guard let testADID = await testADIDStorage.get() else {
      XCTFail()
      return
    }
    XCTAssertEqual(testADID, mockADID)
    await store.receive(
      .downloadMaskImageResponse(
        TaskResult {
          try await testDownloadMaskImage(testADID)
        }
      )
    )
  }
  
  func testDownloadMaskImageResponseSuccess() async {
    let mockMaskImage = UIImage()
    let testInitMaskImageStorage = Shared.testValue.makeAD.initMaskImage
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.downloadMaskImageResponse(.success(mockMaskImage))) {
      $0.isSuccessUpload = true
    }
    await testInitMaskImageStorage.set(mockMaskImage)
    let testInitMaskImage = await testInitMaskImageStorage.get()
    XCTAssertEqual(testInitMaskImage, mockMaskImage)
    await store.receive(.setLoadingView(false))
    await store.receive(.toggleCropImageView)
  }
  
  func testDownloadMaskImageResponseFailure() async {
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.downloadMaskImageResponse(.failure(MockError.mock))) {
      $0.isSuccessUpload = false
    }
    await store.receive(.setLoadingView(false))
    await store.receive(.showNetworkErrorAlert)
  }
  
  func testOnDismissCropImageView() async {
    let testStepBar = Shared.testValue.stepBar
    let state = FindingTheCharacterFeature.State(
      isSuccessUpload: true
    )
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    await store.send(.onDismissCropImageView) {
      $0.isSuccessUpload = false
    }
    let testCompleteStep = await testStepBar.completeStep.get()
    let testCurrentStep = await testStepBar.currentStep.get()
    let testIsShowStepStatusBar = await testStepBar.isShowStepStatusBar.get()
    XCTAssertEqual(testCompleteStep, Step.FindingTheCharacter)
    XCTAssertEqual(testCurrentStep, Step.SeparatingCharacter)
    XCTAssertEqual(testIsShowStepStatusBar, true)
  }
  
  func testShowNetworkErrorAlert() async {
    let state = FindingTheCharacterFeature.State()
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    await store.send(.showNetworkErrorAlert) {
      $0.isShowNetworkErrorAlert = !$0.isShowNetworkErrorAlert
    }
  }
  
  func testInitState() async {
    let state = FindingTheCharacterFeature.State(
      checkState: true
    )
    let store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
    }
    
    await store.send(.initState) {
      $0 = FindingTheCharacterFeature.State()
    }
  }
}
