//
//  FindingCharacterJointsTests.swift
//  FindingCharacterJointsTests
//
//  Created by minii on 2023/10/17.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import FindingCharacterJointsFeatures
import ADComposableArchitecture
import DomainModel
import SharedProvider
import NetworkProvider

@MainActor
final class FindingCharacterJointsTests: XCTestCase {
  enum MockError: Error {
    case mock
  }
  
  func testCheckAction() async {
    let state = FindingCharacterJointsFeature.State()
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    await store.send(.checkAction) {
      $0.checkState = !$0.checkState
    }
  }
  
  func testToggleModifyJointsView() async {
    let state = FindingCharacterJointsFeature.State()
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    await store.send(.toggleModifyJointsView) {
      $0.isShowModifyJointsView = !$0.isShowModifyJointsView
    }
  }
  
  func testSetLoadingView() async {
    let state = FindingCharacterJointsFeature.State()
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    await store.send(.setLoadingView(true)) {
      $0.isShowLoadingView = true
    }
  }
  
  func testFindCharacterJoints() async {
    let mockJoints = Joints.mockData()!
    let testMakeADStorage = Shared.testValue.makeAD
    let mockADID = "testFindCharacterJoints"
    await testMakeADStorage.ad_id.set(mockADID)
    let testFindCharacterJointsProvider = MakeADProvider.testValue.findCharacterJoints
    let state = FindingCharacterJointsFeature.State()
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.findCharacterJoints(mockJoints))
    guard let testADID = await testMakeADStorage.ad_id.get() else {
      XCTFail()
      return
    }
    XCTAssertEqual(mockADID, testADID)
    guard let testJoints = await testMakeADStorage.joints.get() else {
      XCTFail()
      return
    }
    XCTAssertEqual(mockJoints, testJoints)
    await store.receive(.setLoadingView(true))
    await store.receive(
      .findCharacterJointsResponse(
        TaskResult.empty {
          try await testFindCharacterJointsProvider(testADID, testJoints)
        }
      )
    )
  }
  
  func testFindCharacterJointsResponseSuccess() async {
    let state = FindingCharacterJointsFeature.State()
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.findCharacterJointsResponse(.success(TaskEmptyResultValue()))) {
      $0.isSuccessFindCharacterJoints = true
    }
    await store.receive(.setLoadingView(false))
    await store.receive(.toggleModifyJointsView)
  }
  
  func testFindCharacterJointsResponseFailure() async {
    let state = FindingCharacterJointsFeature.State()
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.findCharacterJointsResponse(.failure(MockError.mock))) {
      $0.isSuccessFindCharacterJoints = false
    }
    await store.receive(.setLoadingView(false))
    await store.receive(.showNetworkErrorAlert)
  }
  
  func testOnDismissModifyJointsView() async {
    let testStepBarStorage = Shared.testValue.stepBar
    let mockADViewState = ADViewState.testValue(currentView: .MakeAD)
    let state = FindingCharacterJointsFeature.State(
      isSuccessFindCharacterJoints: true
    )
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    } withDependencies: {
      $0.adViewState = mockADViewState
    }
    
    await store.send(.onDismissModifyJointsView) {
      $0.isSuccessFindCharacterJoints = false
    }
    let testCompleteStep = await testStepBarStorage.completeStep.get()
    let currentView = await mockADViewState.currentView.get()
    XCTAssertEqual(testCompleteStep, .FindingCharacterJoints)
    XCTAssertEqual(currentView, .ConfigureAnimation)
  }
  
  func testShowNetworkErrorAlert() async {
    let state = FindingCharacterJointsFeature.State()
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    await store.send(.showNetworkErrorAlert) {
      $0.isShowNetworkErrorAlert = !$0.isShowNetworkErrorAlert
    } 
  }
  
  func testInitState() async {
    let state = FindingCharacterJointsFeature.State(
      checkState: true
    )
    let store = TestStore(initialState: state) {
      FindingCharacterJointsFeature()
    }
    
    await store.send(.initState) {
      $0 = FindingCharacterJointsFeature.State()
    }
  }
}
