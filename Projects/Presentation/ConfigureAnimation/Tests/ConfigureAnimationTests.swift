//
//  ConfigureAnimationTests.swift
//  ConfigureAnimationTests
//
//  Created by minii on 2023/10/14.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
import ComposableArchitecture
@testable import ConfigureAnimationFeatures

import SharedStorage
import DomainModel

@MainActor
final class ConfigureAnimationTests: XCTestCase {
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
    let store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
    
    store.exhaustivity = .off
    
    await store.send(.toggleIsShowShareActionSheet)
    await store.receive(.showAlertShared(.initAlertShareAction()))
  }
  
  func testToggleIsShowShareActionSheetURLNotNil() async {
    let mockURL = URL(string: "https://www.apple.com")
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
}


// MARK: - AlertState

fileprivate extension AlertState {
  static func initAlertShareAction() -> AlertState<ConfigureAnimationFeature.AlertShared> {
    return .init(
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
  }
}
