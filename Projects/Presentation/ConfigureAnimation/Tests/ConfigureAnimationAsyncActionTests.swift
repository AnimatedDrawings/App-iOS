//
//  ConfigureAnimationAsyncActionTests.swift
//  ConfigureAnimationTests
//
//  Created by chminii on 4/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
@testable import ConfigureAnimationFeatures
import LocalFileProvider
import LocalFileProviderInterfaces
import DomainModels
import ADErrors
import NetworkStorageInterfaces

final class ConfigureAnimationAsyncActionTests: XCTestCase {
  var store: TestStoreOf<ConfigureAnimationFeature>!
  
  override func setUp() {
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  }
  
  func testSaveGifInPhotosSuccess() async {
    let url: URL = .init(filePath: "")
    
    await store.send(.async(.saveGifInPhotos(url)))
    
    store.exhaustivity = .off
    await store.receive(.inner(.alertSaveGifResult(true)))
  }
  
  func testSaveGifInPhotosFail() async {
    store = TestStore(initialState: .init()) {
      ConfigureAnimationFeature()
    } withDependencies: {
      $0.localFileProvider = TestLocalFileProviderImpl(isSuccessSaveGIF: false)
    }
    let url: URL = .init(filePath: "")
    
    await store.send(.async(.saveGifInPhotos(url)))
    
    store.exhaustivity = .off
    await store.receive(.inner(.alertSaveGifResult(false)))
  }
  
  func testSelectAnimationInCache() async {
    let animation: ADAnimation = .zombie
    var cache = ConfigureAnimationFeature.initCache()
    let animationFile: ConfigureAnimationFeature.ADAnimationFile = .init()
    cache[animation] = .init()
    let state = ConfigureAnimationFeature.State(cache: cache)
    store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    
    await store.send(.async(.startRendering(animation))) {
      $0.currentAnimation = animationFile
      $0.configure.animationListView = !$0.configure.animationListView
    }
  }
  
  func testSelectAnimationNotInCache() async {
    let animation: ADAnimation = .zombie
    await store.send(.async(.startRendering(animation))) {
      $0.configure.selectedAnimation = animation
    }
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(true)))
    await store.receive(.async(.selectAnimationResponse(TaskEmptyResult.empty {})))
  }
  
  func testSelectAnimationResponseSuccess() async {
    await store.send(.async(.selectAnimationResponse(.success(.init()))))
    
    store.exhaustivity = .off
    await store.receive(.async(.downloadVideo))
  }
  
  func testSelectAnimationResponseFail() async {
    let error = NetworkStorageError.server
    await store.send(.async(.selectAnimationResponse(.failure(error))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setViewNeworkFail))
  }
  
  func testDownloadVideo() async {
    let animation: ADAnimation = .zombie
    let state = ConfigureAnimationFeature.State(configure: .init(selectedAnimation: animation))
    store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    let response: DownloadAnimationResponse = .mock()
    
    await store.send(.async(.downloadVideo))
    
    store.exhaustivity = .off
    await store.receive(.async(.downloadVideoResponse(.success(response))))
  }
  
  func testDownloadVideoResponseSuccess() async {
    let animation: ADAnimation = .zombie
    let state = ConfigureAnimationFeature.State(configure: .init(selectedAnimation: animation))
    store = TestStore(initialState: state) {
      ConfigureAnimationFeature()
    }
    let saveLocalFileResponse: SaveLocalFileResponse = .mock()
    let response: DownloadAnimationResponse = .mock()
    let animationFile: ConfigureAnimationFeature.ADAnimationFile = .init(
      data: response.animation,
      url: saveLocalFileResponse.fileURL
    )
    
    await store.send(.async(.downloadVideoResponse(.success(response)))) {
      $0.currentAnimation = animationFile
      $0.cache[animation] = animationFile
    }
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.toggleAnimationListView))
  }
  
  func testDownloadVideoResponseFail() async {
    let error = NetworkStorageError.server
    await store.send(.async(.downloadVideoResponse(.failure(error))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.setViewNeworkFail))
  }
}


