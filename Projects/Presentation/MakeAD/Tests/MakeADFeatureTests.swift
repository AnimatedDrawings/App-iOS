//
//  MakeADFeatureTests.swift
//  MakeADTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import MakeADFeatures
import ADComposableArchitecture
import ADUIKitResources
import DomainModel

@MainActor
final class MakeADFeatureScopeTests: XCTestCase {
  var store: TestStoreOf<MakeADFeature>!
  
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      MakeADFeature()
    }
  }
  
  func testUploadADrawing() async {
    let mockImage = ADUIKitResourcesAsset.TestImages.garlic.image
    
    await store.send(.scope(.uploadADrawing(.delegate(.setOriginalImage(mockImage))))) {
      $0.makeADInfo.originalImage = mockImage
    }
  }
  
  func testSetBoundingBox() async {
    let mockBoundingBox = CGRect(x: 1, y: 1, width: 1, height: 1)
    
    await store.send(.scope(.uploadADrawing(.delegate(.setBoundingBox(mockBoundingBox))))) {
      $0.makeADInfo.boundingBox = mockBoundingBox
    }
  }
}
