//
//  ConfigureAnimationTests.swift
//  ConfigureAnimationTests
//
//  Created by minii on 2023/10/14.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
import ThirdPartyLib
@testable import ConfigureAnimationFeatures
import SharedStorage
import DomainModel
import NetworkProvider
import LocalFileProvider
import SharedProvider

@MainActor
final class ConfigureAnimationTests: XCTestCase {
  var mockURL: URL!
  var mockADAnimation: ADAnimation!
  var mockCache: [ADAnimation : URL?]!
  var mockError: MockError!
  var mockData: Data!
  
  override func setUp() {
    super.setUp()
    
    mockURL = URL(string: "https://www.apple.com")!
    mockADAnimation = .zombie
    mockCache = [mockADAnimation : mockURL]
    mockError = .mock
    mockData = Data()
  }
  
  enum MockError: Error {
    case mock
  }
  
  func testFixMakeAD() async {
    let mockADViewCaseStorage = Shared.testValue.adViewCase
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.fixMakeAD)
    
    let mockADViewCase = await mockADViewCaseStorage.get()
    XCTAssertEqual(ADViewCase.MakeAD, mockADViewCase)
  }
  
  func testToggleIsShowAnimationListView() async {
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.toggleIsShowAnimationListView) {
      $0.isShowAnimationListView = !$0.isShowAnimationListView
    }
  }
  
  func testToggleIsShowShareView() async {
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.toggleIsShowShareView) {
      $0.isShowShareView = !$0.isShowShareView
    }
  }
  
  func testToggleIsShowShareActionSheetURLNil() async {
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.toggleIsShowShareActionSheet)
    await store.receive(.showNoAnimationFileAlert)
  }
  
  func testToggleIsShowShareActionSheetURLNotNil() async {
    let state = ConfigureAnimationFeature.State(myAnimationURL: mockURL)
    let store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.toggleIsShowShareActionSheet) {
      $0.isShowActionSheet = !$0.isShowActionSheet
    }
  }
  
  func testSetLoadingView() async {
    let flag = true
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.setLoadingView(flag)) {
      $0.isShowLoadingView = flag
    }
  }
  
  func testSelectAnimationNotInCache() async {
    let testString = "test"
    let mockADIDStorage = SharedProvider.Shared.testValue.makeAD.ad_id
    await mockADIDStorage.set(testString)
    let testAdd = ConfigureAnimationProvider.testValue.add
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.selectAnimation(mockADAnimation))
    guard let ad_id = await mockADIDStorage.get() else {
      XCTFail()
      return
    }
    
    await store.receive(.setLoadingView(true))
    await store.receive(
      .addAnimationResponse(
        TaskResult.empty {
          try await testAdd(ad_id, mockADAnimation)
        }
      )
    )
  }
  
  func testSelectAnimationInCache() async {
    let store = TestStore(
      initialState: ConfigureAnimationFeature.State(
        cache: mockCache
      )
    ) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.selectAnimation(mockADAnimation)) {
      $0.selectedAnimation = self.mockADAnimation
      $0.isSuccessAddAnimation = true
    }
    
    await store.receive(.toggleIsShowAnimationListView) {
      $0.isShowAnimationListView = !$0.isShowAnimationListView
    }
  }
  
  func testAddAnimationResponseSuccess() async {
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.addAnimationResponse(.success(TaskEmptyResultValue())))
    await store.receive(.downloadVideo)
  }
  
  func testAddAnimationResponseFailure() async {
    let store = TestStore(
      initialState: ConfigureAnimationFeature.State(isShowLoadingView: true)
    ) {
      ConfigureAnimationFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.addAnimationResponse(.failure(mockError)))
    await store.receive(.setLoadingView(false)) {
      $0.isShowLoadingView = false
    }
    await store.receive(.showNetworkErrorAlert)
  }
  
  func testDownloadVideo() async {
    let testString = "test"
    let mockADIDStorage = SharedProvider.Shared.testValue.makeAD.ad_id
    await mockADIDStorage.set(testString)
    let testDownload = ConfigureAnimationProvider.testValue.download
    let mockState = ConfigureAnimationFeature.State(selectedAnimation: mockADAnimation)
    let store = TestStore(initialState: mockState) {
      ConfigureAnimationFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.downloadVideo)
    guard let ad_id = await mockADIDStorage.get() else {
      XCTFail()
      return
    }
    await store.receive(
      .downloadVideoResponse(
        TaskResult {
          try await testDownload(ad_id, mockADAnimation)
        }
      )
    )
  }
  
  func testDownloadVideoResponseSuccess() async {
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.downloadVideoResponse(.success(mockData)))
    await store.receive(.addToCache(mockURL!))
    await store.receive(.setLoadingView(false))
    await store.receive(.toggleIsShowAnimationListView)
  }
  
  func testDownloadVideoResponseFailure() async {
    let mockState = ConfigureAnimationFeature.State(isShowLoadingView: true)
    let store = TestStore(initialState: mockState) {
      ConfigureAnimationFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.downloadVideoResponse(.failure(MockError.mock)))
    await store.receive(.setLoadingView(false)) {
      $0.isShowLoadingView = false
    }
    await store.receive(.showNetworkErrorAlert)
  }
  
  func testOnDismissAnimationListView() async {
    let mockState = ConfigureAnimationFeature.State(
      selectedAnimation: mockADAnimation,
      cache: mockCache,
      isSuccessAddAnimation: true
    )
    let store = TestStore(initialState: mockState) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.onDismissAnimationListView) {
      $0.myAnimationData = self.mockData
      $0.myAnimationURL = self.mockURL
      $0.isSuccessAddAnimation = false
    }
  }
  
  func testAddToCache() async {
    let mockState = ConfigureAnimationFeature.State(
      selectedAnimation: mockADAnimation
    )
    let store = TestStore(initialState: mockState) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.addToCache(mockURL)) {
      $0.cache[self.mockADAnimation] = self.mockURL
      $0.isSuccessAddAnimation = true
    }
  }
  
//  func testSaveGIFInPhotos() async {
//    let mockState = ConfigureAnimationFeature.State()
//    let store = TestStore(initialState: mockState) {
//      ConfigureAnimationFeature()
//    }
//  }
}
