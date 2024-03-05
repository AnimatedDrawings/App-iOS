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

@MainActor
final class CropImageViewActionTests: XCTestCase {
  var state: CropImageFeature.State!
  var store: TestStoreOf<CropImageFeature>!
  
  override func setUp() async throws {
    let example1 = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
    let boundingBox = BoundingBoxDTO.mock().toCGRect()
    state = CropImageFeature.State(originalImage: example1, boundingBox: boundingBox)
    store = TestStore(initialState: state) {
      CropImageFeature()
    }
  }
  
  func testSave() async {
    let example1 = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
    let boundingBox = BoundingBoxDTO.mock().toCGRect()
    state = CropImageFeature.State(
      originalImage: example1,
      boundingBox: boundingBox,
      viewBoundingBox: boundingBox
    )
    store = TestStore(initialState: state) {
      CropImageFeature()
        .dependency(ImageCropper.testValue)
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


