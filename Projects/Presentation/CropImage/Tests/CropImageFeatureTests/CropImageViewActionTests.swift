//
//  CropImageViewActionTests.swift
//  CropImageExample
//
//  Created by chminii on 3/4/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import CropImageFeatures
import ADComposableArchitecture
import ADResources
import ImageToolsInterfaces
import CropImageInterfaces

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
    state.viewBoundingBox = state.imageBoundingBox.cgRect
    store = TestStore(initialState: state) {
      CropImageFeature()
    }
    
    let cropResponse = CropResponse.mock()
    let cropImageResult = CropImageResult(
      image: cropResponse.image,
      boundingBox: .init(cgRect: cropResponse.boundingBox)
    )
    await store.send(.view(.save))
    await store.receive(.delegate(.cropImageResult(cropImageResult)))
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
