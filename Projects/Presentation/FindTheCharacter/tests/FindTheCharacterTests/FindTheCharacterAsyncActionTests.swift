//
//  FindTheCharacterAsyncActionTests.swift
//  FindTheCharacterTests
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindTheCharacterFeatures
import ADComposableArchitecture
import CropImageInterfaces
import ADErrors
import NetworkProviderInterfaces
import FindTheCharacterInterfaces

final class FindTheCharacterAsyncActionTests: XCTestCase {
  var store: TestStoreOf<FindTheCharacterFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      FindTheCharacterFeature()
    }
  }
  
  func testFindTheCharacter() async {
    let cropImageResult: CropImageResult = .mock()
    
    await store.send(.async(.findTheCharacter(cropImageResult))) {
      $0.croppedUIImage = cropImageResult.image
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
    let error = NetworkStorageError.server
    
    await store.send(.async(.findTheCharacterResponse(.failure(error))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.networkErrorAlert))
  }
  
  func testDownloadMaskImage() async {
    let response: DownloadMaskImageResponse = .mock()
    
    await store.send(.async(.downloadMaskImage))
    
    store.exhaustivity = .off
    await store.receive(.async(.downloadMaskImageResponse(.success(response))))
  }
  
  func testDownloadMaskImageResponseSuccess() async {
    let cropImage = UIImage()
    let maskImage = UIImage()
    store = TestStore(initialState: .init(croppedUIImage: cropImage)) {
      FindTheCharacterFeature()
    }
    let findingTheCharacterResult = FindTheCharacterResult(
      cropImage: cropImage,
      maskImage: maskImage
    )
    let downloadMaskImageResponse: DownloadMaskImageResponse = .init(image: maskImage)
    
    await store.send(.async(.downloadMaskImageResponse(.success(downloadMaskImageResponse))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.view(.toggleCropImageView))
    await store.receive(.delegate(.moveToSeparatingCharacter(findingTheCharacterResult)))
  }
  
  func testDownloadMaskImageResponseFail() async {
    let error = NetworkStorageError.server
    
    await store.send(.async(.downloadMaskImageResponse(.failure(error))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.networkErrorAlert))
  }
}
