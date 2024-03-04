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
import CoreModel
import ADUIKitSources

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
  
  func testSave() {
    
  }
  
  func testCancel() {
    
  }
  
  func testReset() async {
    await store.send(.view(.reset)) {
      $0.resetTrigger = !$0.resetTrigger
    }
  }
}
