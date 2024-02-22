//
//  UploadADrawingInnerActionTests.swift
//  UploadADrawingTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadADrawingFeatures
import ThirdPartyLib
import DomainModel

@MainActor
final class UploadADrawingInnerActionTests: XCTestCase {
  var state: UploadADrawingFeature.State!
  var store: TestStoreOf<UploadADrawingFeature>!
  
  override func setUp() async throws {
    state = UploadADrawingFeature.State()
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
  }
  
  func testSetLoadingView() async {
    await store.send(.inner(.setLoadingView(true))) {
      $0.isShowLoadingView = true
    }
  }
  
  func testMoveToFindingTheCharacter() async {
    await store.send(.inner(.moveToFindingTheCharacter)) {
      $0.stepBar = StepBarState(
        isShowStepBar: true,
        currentStep: .FindingTheCharacter,
        completeStep: .UploadADrawing
      )
    }
  }
  
  func testShowNetworkErrorAlert() async {
    var isShow = true
    state = UploadADrawingFeature.State(isShowNetworkErrorAlert: isShow)
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.inner(.showNetworkErrorAlert)) {
      $0.isShowNetworkErrorAlert = !isShow
    }
  }
  
  func testShowFindCharacterErrorAlert() async {
    var isShow = true
    state = UploadADrawingFeature.State(isShowFindCharacterErrorAlert: isShow)
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.inner(.showFindCharacterErrorAlert)) {
      $0.isShowFindCharacterErrorAlert = !isShow
    }
  }
  
  func testShowImageSizeErrorAlert() async {
    var isShow = true
    state = UploadADrawingFeature.State(isShowImageSizeErrorAlert: isShow)
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    }
    
    await store.send(.inner(.showImageSizeErrorAlert)) {
      $0.isShowImageSizeErrorAlert = !isShow
    }
  }
}
