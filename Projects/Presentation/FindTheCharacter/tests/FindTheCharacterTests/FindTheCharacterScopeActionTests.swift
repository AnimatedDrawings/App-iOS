//
//  FindTheCharacterScopeActionTests.swift
//  FindTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindTheCharacterFeatures
@testable import CropImageFeatures
import ADComposableArchitecture
import CropImageInterfaces

final class FindTheCharacterScopeActionTests: XCTestCase {
  var store: TestStoreOf<FindTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    let cropImageState = CropImageFeature.State.mock()
    let state = FindTheCharacterFeature.State(cropImage: cropImageState)
    store = TestStore(initialState: state) {
      FindTheCharacterFeature()
    }
  }
  
  func testCropImageResult() async {
    let cropImageResult: CropImageResult = .mock()
    
    await store.send(.scope(.cropImage(.delegate(.cropImageResult(cropImageResult)))))
    
    store.exhaustivity = .off
    await store.receive(.async(.findTheCharacter(cropImageResult)))
  }
  
  func testCancel() async {
    await store.send(.scope(.cropImage(.delegate(.cancel))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.toggleCropImageView))
  }
}
