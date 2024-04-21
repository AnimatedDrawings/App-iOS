//
//  SeparateCharacterAsyncActionTests.swift
//  SeparateCharacterTests
//
//  Created by chminii on 4/2/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import SeparateCharacterFeatures
import MaskImageInterfaces
import NetworkProviderInterfaces
import SeparateCharacterInterfaces
import ADResources
import ADErrors

final class SeparateCharacterAsyncActionTests: XCTestCase {
  var store: TestStoreOf<SeparateCharacterFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      SeparateCharacterFeature()
    }
  }
  
  func testSeparateCharacter() async {
    let maskImageResult: MaskImageResult = .mock()
    
    await store.send(.async(.separateCharacter(maskImageResult))) {
      $0.maskedImage = maskImageResult.image
    }
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(true)))
    await store.receive(.async(.separateCharacterResponse(.success(SeparateCharacterResponse.mock()))))
  }
  
  func testSeparateCharacterResponseSuccess() async {
    let maskedImage: UIImage = ADResourcesAsset.TestImages.maskedImage.image
    let state = SeparateCharacterFeature.State(maskedImage: maskedImage)
    store = TestStore(initialState: state) {
      SeparateCharacterFeature()
    }
    let separateCharacterResponse: SeparateCharacterResponse = .mock()
    let separateCharacterResult = SeparateCharacterResult(
      maskedImage: maskedImage,
      joints: separateCharacterResponse.joints
    )
    
    await store.send(.async(.separateCharacterResponse(.success(separateCharacterResponse))))
    store.exhaustivity = .off
    
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.popMaskImageView))
    await store.receive(.delegate(.moveToFindCharacterJoints(separateCharacterResult)))
  }
  
  func testSeparateCharacterResponseFail() async {
    let error = NetworkStorageError.server
    
    await store.send(.async(.separateCharacterResponse(.failure(error))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.networkErrorAlert))
  }
}
