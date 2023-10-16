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

@MainActor
final class ConfigureAnimationTests: XCTestCase {
  let mockURL = URL(string: "https://www.apple.com")
  enum MockError: Error {
    case mock
  }
  
  func testFixMakeAD() async {
    let mockSharedADViewCase = CombineNotifier<ADViewCase>(initialValue: .OnBoarding)
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    } withDependencies: {
      $0.shared.adViewCase = mockSharedADViewCase
    }

    await store.send(.fixMakeAD)
    
    let mockADViewCase = await mockSharedADViewCase.get()
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
    let mockAlertState: AlertState<ConfigureAnimationFeature.AlertShared> = .init(
      title: {
        TextState("No Animated Drawings File")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState("The file does not exist. Make a Animation First")
      }
    )
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.toggleIsShowShareActionSheet)
    await store.receive(.showAlertShared(mockAlertState)) {
      $0.alertShared = mockAlertState
    }
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
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    let flag = true
    
    await store.send(.setLoadingView(flag)) {
      $0.isShowLoadingView = flag
    }
  }
  
  func testSelectAnimationNotInCache() async {
    let mockADIDStorage = CombineNotifier<String?>(initialValue: "test")
    let mockADAnimation: ADAnimation = .zombie
    let testAdd = ConfigureAnimationProvider.testValue.add
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    } withDependencies: {
      $0.shared.makeAD.ad_id = mockADIDStorage
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
    let mockADAnimation: ADAnimation = .zombie
    let mockCache: [ADAnimation : URL?] = [
      mockADAnimation : mockURL
    ]
    let store = TestStore(
      initialState: ConfigureAnimationFeature.State(
        cache: mockCache
      )
    ) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.selectAnimation(mockADAnimation)) {
      $0.selectedAnimation = mockADAnimation
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
    let mockAlertState: AlertState<ConfigureAnimationFeature.AlertShared> = .init(
      title: {
        TextState("Connection Error")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState("Please check device network condition.")
      }
    )
    let store = TestStore(
      initialState: ConfigureAnimationFeature.State(isShowLoadingView: true)
    ) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.addAnimationResponse(.failure(MockError.mock)))
    await store.receive(.setLoadingView(false)) {
      $0.isShowLoadingView = false
    }
    await store.receive(.showAlertShared(mockAlertState)) {
      $0.alertShared = mockAlertState
    }
  }
  
  func testDownloadVideo() async {
    let mockADIDStorage = CombineNotifier<String?>(initialValue: "test")
    let mockSelectedAnimation: ADAnimation = .zombie
    let testDownload = ConfigureAnimationProvider.testValue.download
    let mockState = ConfigureAnimationFeature.State(selectedAnimation: mockSelectedAnimation)
    let store = TestStore(initialState: mockState) {
      ConfigureAnimationFeature()
    } withDependencies: {
      $0.shared.makeAD.ad_id = mockADIDStorage
    }
    
    await store.send(.downloadVideo)
    
    guard let ad_id = await mockADIDStorage.get() else {
      XCTFail()
      return
    }
    
    store.exhaustivity = .off
    
    await store.receive(
      .downloadVideoResponse(
        TaskResult {
          try await testDownload(ad_id, mockSelectedAnimation)
        }
      )
    )
  }
  
  func testDownloadVideoResponseSuccess() async {
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    
    
  }
  
  
}
