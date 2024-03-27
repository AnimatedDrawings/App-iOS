//
//  FindingTheCharacterScopeActionTests.swift
//  FindingTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindingTheCharacterFeatures
@testable import CropImageFeatures
import ADComposableArchitecture
import CropImageInterfaces

final class FindingTheCharacterScopeActionTests: XCTestCase {
  var store: TestStoreOf<FindingTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    let cropImageState = CropImageFeature.State.mock()
    let state = FindingTheCharacterFeature.State(cropImage: cropImageState)
    store = TestStore(initialState: state) {
      FindingTheCharacterFeature()
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
