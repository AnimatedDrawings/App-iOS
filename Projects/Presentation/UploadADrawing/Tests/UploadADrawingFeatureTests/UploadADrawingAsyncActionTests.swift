//
//  UploadADrawingAsyncActionTests.swift
//  UploadADrawingFeatures
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadADrawingFeatures
import ThirdPartyLib
import ADUIKitResources
import DomainModel
import NetworkStorage
import SharedProvider
import ImageTools

final class UploadADrawingAsyncActionTests: XCTestCase {
  var store: TestStoreOf<UploadADrawingFeature>!
  
  @MainActor
  override func setUp() async throws {
    store = TestStore(initialState: .init()) {
      UploadADrawingFeature()
    }
  }
  
  func testUploadDrawing() async {
    let mockCompressedInfo = CompressedInfo.mock()
    
    await store.send(.async(.uploadDrawing(mockCompressedInfo.data))) {
      $0.originalImage = mockCompressedInfo.original
    }
    
    store.exhaustivity = .off
    await store.receive(.inner(.setLoadingView(true)))
    await store.receive(
      .async(
        .uploadDrawingResponse(
          TaskResult<UploadDrawingResult>
            .success(UploadDrawingResult.example1Mock())
        )
      )
    )
  }
  
  func testUploadDrawingResponseSuccess() async {
    let mockResponse = UploadDrawingResult.example1Mock()
    let mockUploadADrawingResult = UploadADrawingResult(
      originalImage: UIImage(),
      boundingBox: mockResponse.boundingBox
    )
    
    store.exhaustivity = .off
    await store.send(
      .async(
        .uploadDrawingResponse(
          .success(mockResponse)
        )
      )
    )
    
    guard let ad_id = await ADInfo.testValue.id.get() else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(ad_id, mockResponse.ad_id)
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.delegate(.moveToFindingTheCharacter(mockUploadADrawingResult)))
  }
  
  func testUploadDrawingResponseFail() async {
    let findCharacterError = NetworkError.ADServerError
    store.exhaustivity = .off
    await store.send(
      .async(
        .uploadDrawingResponse(
          .failure(findCharacterError)
        )
      )
    )
    await store.receive(.inner(.showFindCharacterErrorAlert))
    
    let networkError = NetworkError.convertResponseModel
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
