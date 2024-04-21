//
//  FindCharacterJointsAsyncActionTests.swift
//  FindCharacterJointsTests
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindCharacterJointsFeatures
import ADComposableArchitecture
import DomainModels
import ADErrors

final class FindCharacterJointsAsyncActionTests: XCTestCase {
  var store: TestStoreOf<FindCharacterJointsFeature>!
  
  override func setUp() {
    let state: FindCharacterJointsFeature.State = .init()
    store = TestStore(initialState: state) {
      FindCharacterJointsFeature()
    }
  }
  
  func testFindCharacterJoints() async {
    let joints: Joints = .mock()
    await store.send(.async(.findCharacterJoints(joints)))
    
    store.exhaustivity = .off
    
    await store.receive(.inner(.setLoadingView(true)))
    await store.receive(.async(.findCharacterJointsResponse(TaskEmptyResult.empty {})))
  }
  
  func testFindCharacterJointsResponseSuccess() async {
    await store.send(.async(.findCharacterJointsResponse(.success(.init()))))
    
    store.exhaustivity = .off
    
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.popModifyJointsView))
    await store.receive(.delegate(.findCharacterJointsResult))
  }
  
  func testFindCharacterJointsResponseFail() async {
    let error = NetworkStorageError.server
    await store.send(.async(.findCharacterJointsResponse(.failure(error))))
    
    store.exhaustivity = .off
    
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.networkErrorAlert))
  }
  
}
