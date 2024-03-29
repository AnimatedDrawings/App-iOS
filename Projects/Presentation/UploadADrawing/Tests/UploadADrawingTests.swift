//
//  UploadADrawingTests.swift
//  UploadADrawingTests
//
//  Created by minii on 2023/10/16.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import UploadADrawingFeatures
import ThirdPartyLib
import SharedProvider
import NetworkProvider
import DomainModel
import ADUIKitResources

@MainActor
final class UploadADrawingTests: XCTestCase {
  enum MockError: Error {
    case mock
  }
  
  func testCheckList() async {
    let state = UploadADrawingFeature.State()
    let store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.checkList1) {
      $0.checkState1 = !$0.checkState1
    }
    await store.send(.checkList2) {
      $0.checkState2 = !$0.checkState2
    }
    await store.send(.checkList3) {
      $0.checkState3 = !$0.checkState3
    }
    await store.send(.checkList4) {
      $0.checkState4 = !$0.checkState4
      $0.isEnableUploadButton = true
    }
  }
  
  func testSetIsShowLoadingView() async {
    let state = UploadADrawingFeature.State()
    let store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.setIsShowLoadingView(true)) {
      $0.isShowLoadingView = true
    }
  }
  
  func testUploadDrawing() async {
    let mockImageData: Data = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image.pngData()!
    let testOriginalImageStorage = Shared.testValue.makeAD.originalImage
    let testUploadDrawing = MakeADProvider.testValue.uploadDrawing
    let state = UploadADrawingFeature.State()
    let store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.uploadDrawing(mockImageData))
    await store.receive(.setIsShowLoadingView(true))
    await store.receive(
      .uploadDrawingResponse(
        TaskResult {
          try await testUploadDrawing(mockImageData)
        }
      )
    )
    await store.receive(.setIsShowLoadingView(false))
    await store.receive(.uploadDrawingNextAction)
  }
  
  func testUploadDrawingResponseSuccess() async {
    let mockADID = "testMockADID"
    let mockBoundingBox = CGRect(x: 1, y: 1, width: 1, height: 1)
    let mockUploadDrawingResult = UploadDrawingResult(
      ad_id: mockADID,
      boundingBox: mockBoundingBox
    )
    let testADIDStorage = Shared.testValue.makeAD.ad_id
    let testBouningBoxStorage = Shared.testValue.makeAD.boundingBox
    let state = UploadADrawingFeature.State()
    let store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.uploadDrawingResponse(.success(mockUploadDrawingResult))) {
      $0.isSuccessUploading = true
    }
    
    let testADID = await testADIDStorage.get()
    let testBoundingBox = await testBouningBoxStorage.get()
    
    XCTAssertEqual(mockADID, testADID)
    XCTAssertEqual(mockBoundingBox, testBoundingBox)
  }
  
  func testUploadDrawingResponseFailure() async {
    let state = UploadADrawingFeature.State(
      isSuccessUploading: true
    )
    let store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.uploadDrawingResponse(.failure(MockError.mock))) {
      $0.isSuccessUploading = false
    }
    await store.receive(.showNetworkErrorAlert)
  }
  
  func testUploadDrawingNextAction() async {
    let testStepBar = Shared.testValue.stepBar
    let state = UploadADrawingFeature.State(
      isSuccessUploading: true
    )
    let store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.uploadDrawingNextAction) {
      $0.isSuccessUploading = false
    }
    
    let testCompleteStep = await testStepBar.completeStep.get()
    let testCurrentStep = await testStepBar.currentStep.get()
    let testIsShowStepStatusBar = await testStepBar.isShowStepStatusBar.get()
    
    XCTAssertEqual(testCompleteStep, .UploadADrawing)
    XCTAssertEqual(testCurrentStep, .FindingTheCharacter)
    XCTAssertEqual(testIsShowStepStatusBar, true)
  }
}
