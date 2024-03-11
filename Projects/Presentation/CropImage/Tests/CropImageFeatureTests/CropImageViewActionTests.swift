//
//  CropImageViewActionTests.swift
//  CropImageExample
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import CropImageFeatures
import ThirdPartyLib
import ADUIKitResources
import DomainModel
import ImageTools
import CoreModel

final class CropImageViewActionTests: XCTestCase {
  var store: TestStoreOf<CropImageFeature>!
  
  @MainActor
  override func setUp() async throws {
    let state = CropImageFeature.State.mock()
    store = TestStore(initialState: state) {
      CropImageFeature()
    }
  }
  
  func testSave() async {
    var state = CropImageFeature.State.mock()
    state.viewBoundingBox = state.boundingBox
    store = TestStore(initialState: state) {
      CropImageFeature()
    }
    let cropResult = CropResult(image: state.originalImage, boundingBox: state.viewBoundingBox)
    
    await store.send(.view(.save))
    await store.receive(.delegate(.cropResult(cropResult)))
  }
  
  func testCancel() async {
    await store.send(.view(.cancel))
  }
  
  func testReset() async {
    await store.send(.view(.reset)) {
      $0.resetTrigger = !$0.resetTrigger
    }
  }
}
