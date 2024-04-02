//
//  SeparateCharacterScopeActionTests.swift
//  SeparateCharacterTests
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import XCTest
@testable import SeparateCharacterFeatures
import MaskImageFeatures

final class SeparateCharacterScopeActionTests: XCTestCase {
  var store: TestStoreOf<SeparateCharacterFeature>!
  
  override func setUp() {
    let maskImageState: MaskImageFeature.State = .mock()
    let state = SeparateCharacterFeature.State(maskImage: maskImageState)
    store = TestStore(initialState: state) {
      SeparateCharacterFeature()
    }
  }
  
  func testMaskImageResult() async {
    
  }
  
  func testCancel() async {
    await store.send(.scope(.maskImage(.delegate(.cancel))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.popMaskImageView))
  }
}
