//
//  ImageCropperTests.swift
//  ImageCompressorTests
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import ImageTools
import ImageToolsTestings
import ImageToolsInterfaces

final class ImageCropperTests: XCTestCase {
  var imageCropper: ImageCropper!
  
  override func setUp() async throws {
    imageCropper = .liveValue
  }
  
  func testCrop() {
    let cropRequest = CropRequest.mock()
    let cropCGSize = CGSize(
      width: cropRequest.viewBoundingBox.width * cropRequest.imageScale,
      height: cropRequest.viewBoundingBox.height * cropRequest.imageScale
    )
    let cropCGPoint = CGPoint(
      x: -cropRequest.viewBoundingBox.minX * cropRequest.imageScale,
      y: -cropRequest.viewBoundingBox.minY * cropRequest.imageScale
    )
    let mockBoundingBox = CGRect(
      origin: CGPoint(x: -cropCGPoint.x, y: -cropCGPoint.y),
      size: cropCGSize
    )
    
    guard let cropResponse = try? imageCropper.crop(cropRequest) else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(cropResponse.boundingBox, mockBoundingBox)
    XCTAssertEqual(cropResponse.image.size.trunc(), cropCGSize.trunc())
  }
  
  func testTestCrop() {
    imageCropper = .testValue
    
    let mockCropResponse: CropResponse = .mock()
    guard let cropResponse = try? imageCropper.crop(.mock()) else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(cropResponse, mockCropResponse)
  }
}
