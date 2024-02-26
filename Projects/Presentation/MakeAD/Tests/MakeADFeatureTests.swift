//
//  MakeADFeatureTests.swift
//  MakeADTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import MakeADFeatures
import ThirdPartyLib
import ADUIKitResources
import DomainModel

@MainActor
final class MakeADFeatureScopeTests: XCTestCase {
  var store: TestStoreOf<MakeADFeature>!
//  var uploadADrawingStore: TestStoreOf<UploadADrawingFeature>!
  
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      MakeADFeature()
    }
//    uploadADrawingStore = store.store
//      .scope(
//        state: \.uploadADrawing,
//        action: MakeADFeature.Action.scope(.uploadADrawing)
//      )
  }
  
  func testUploadADrawing() async {
    let mockImage = ADUIKitResourcesAsset.TestImages.garlic.image
    
    await store.send(.scope(.uploadADrawing(.delegate(.setOriginalImage(mockImage))))) {
//      $0.makeADInfo = MakeADInfo(originalImage: mockImage)
      $0.makeADInfo.originalImage = mockImage
    }
  }
}
