//
//  FindingTheCharacterAsyncActionTests.swift
//  FindingTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindingTheCharacterFeatures
import ThirdPartyLib
import DomainModel
import NetworkStorage
import ADUIKitResources

final class FindingTheCharacterAsyncActionTests: XCTestCase {
  var store: TestStoreOf<FindingTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      FindingTheCharacterFeature()
    }
  }
  
  func testFindTheCharacter() async {
    let mockCropResult = CropResult.mock()
    
    await store.send(.async(.findTheCharacter(mockCropResult))) {
      $0.cropImageResult = mockCropResult.image
    }
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(true)))
    await store.receive(.async(.findTheCharacterResponse(TaskEmptyResult.empty{})))
  }
  
  func testFindTheCharacterResponseSuccess() async {
    await store.send(.async(.findTheCharacterResponse(.success(.init()))))
    
    store.exhaustivity = .off
    await store.receive(.async(.downloadMaskImage))
  }
  
  func testFindTheCharacterResponseFail() async {
    let mockError = NetworkError.ADServerError
    
    await store.send(.async(.findTheCharacterResponse(.failure(mockError))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.networkErrorAlert))
  }
  
  func testDownloadMaskImage() async {
    await store.send(.async(.downloadMaskImage))
    
    store.exhaustivity = .off
    await store.receive(.async(.downloadMaskImageResponse(.success(UIImage()))))
  }
  
  func testDownloadMaskImageResponseSuccess() async {
    let mockCropImage = UIImage()
    let mockMaskImage = UIImage()
    let mockFindingTheCharacterResult = FindingTheCharacterResult(
      cropImage: mockCropImage,
      maskImage: mockMaskImage
    )
    await store.send(.async(.downloadMaskImageResponse(.success(mockMaskImage))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.view(.toggleCropImageView))
    await store.receive(.delegate(.moveToSeparatingCharacter(mockFindingTheCharacterResult)))
  }
  
  func testDownloadMaskImageResponseFail() async {
    let mockError = NetworkError.ADServerError
    
    await store.send(.async(.downloadMaskImageResponse(.failure(mockError))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.networkErrorAlert))
  }
}
