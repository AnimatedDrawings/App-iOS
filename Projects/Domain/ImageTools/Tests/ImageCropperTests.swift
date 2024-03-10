//
//  ImageCropperTests.swift
//  ImageCompressorTests
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import ImageTools
import DomainModel
import ImageToolsTestings

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
    
    guard let cropResult = try? imageCropper.crop(cropRequest) else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(cropResult.boundingBox, mockBoundingBox)
    XCTAssertEqual(cropResult.image.size.trunc(), cropCGSize.trunc())
  }
  
  func testTestCrop() {
    imageCropper = .testValue
    let cropRequest = CropRequest.mock()
    let mockCropResult = CropResult(
      image: cropRequest.originalImage,
      boundingBox: cropRequest.viewBoundingBox
    )
    
    guard let cropResult = try? imageCropper.crop(cropRequest) else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(cropResult, mockCropResult)
  }
}
