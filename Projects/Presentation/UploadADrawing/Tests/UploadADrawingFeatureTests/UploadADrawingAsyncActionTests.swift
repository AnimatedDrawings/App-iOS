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

@MainActor
final class UploadADrawingAsyncActionTests: XCTestCase {
  var state: UploadADrawingFeature.State!
  var store: TestStoreOf<UploadADrawingFeature>!
  
  override func setUp() async throws {
    state = UploadADrawingFeature.State()
    store = TestStore(initialState: state) {
      UploadADrawingFeature()
    } withDependencies: {
      $0.imageCompressor = ImageCompressorKey.testValue
      $0.makeADProvider = .testValue
      $0.adInfo = .testValue
    }
  }
  
  func testUploadDrawing() async {
    let mockCompressedInfo = CompressedInfo.mock()
    
    store.exhaustivity = .off
    await store.send(.async(.uploadDrawing(mockCompressedInfo.data)))
    
    await store.receive(.delegate(.setOriginalImage(mockCompressedInfo.original)))
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
    let mockData = UploadDrawingResult.example1Mock()
    
    store.exhaustivity = .off
    await store.send(
      .async(
        .uploadDrawingResponse(
          .success(mockData)
        )
      )
    )
    
    guard let id = await ADID.testValue.id.get() else {
      XCTFail()
      return
    }
    XCTAssertEqual(id, mockData.ad_id)
    await store.receive(.delegate(.setBoundingBox(mockData.boundingBox)))
    await store.receive(.inner(.setLoadingView(false)))
    await store.receive(.inner(.moveToFindingTheCharacter))
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
