//
//  UploadDrawingAsyncActionTests.swift
//  UploadDrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadDrawingFeatures
import ADComposableArchitecture
import ADErrors
import ImageToolsInterfaces
import NetworkProviderInterfaces
import UploadDrawingInterfaces
import SharedProvider

final class UploadDrawingAsyncActionTests: XCTestCase {
  var store: TestStoreOf<UploadDrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      UploadDrawingFeature()
    }
  }
  
  func testUploadDrawing() async {
    let compressResponse = CompressResponse.mock()
    
    await store.send(.async(.uploadDrawing(compressResponse.data))) {
      $0.originalImage = compressResponse.original
    }
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(true)))
    await store.receive(
      .async(
        .uploadDrawingResponse(.success(.mock()))
      )
    )
  }
  
  func testUploadDrawingResponseSuccess() async {
    let response = UploadDrawingResponse.mock()
    let result = UploadDrawingResult(
      originalImage: UIImage(),
      boundingBox: response.boundingBox
    )
    
    store.exhaustivity = .off
    await store.send(
      .async(
        .uploadDrawingResponse(
          .success(.mock())
        )
      )
    )
    
    guard let ad_id = await ADInfoProvider.testValue.id.get() else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(ad_id, response.ad_id)
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.delegate(.moveToFindTheCharacter(result)))
  }
  
  func testUploadDrawingResponseFail() async {
    let findCharacterError = NetworkStorageError.server
    store.exhaustivity = .off
    await store.send(
      .async(
        .uploadDrawingResponse(
          .failure(findCharacterError)
        )
      )
    )
    await store.receive(.inner(.showFindCharacterErrorAlert))
    
    let networkError = NetworkStorageError.jsonDecode
    await store.send(
      .async(
        .uploadDrawingResponse(
          .failure(networkError)
        )
      )
    )
    await store.receive(.inner(.showNetworkErrorAlert))
  }
}
