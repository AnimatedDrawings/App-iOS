//
//  ImageCropperTests.swift
//  ImageCompressorTests
//
//  Created by chminii on 3/5/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import ImageCompressor
import DomainModel

final class ImageCropperTests: XCTestCase {
  var imageCropper: ImageCropper!
  
  override func setUp() async throws {
    imageCropper = .liveValue
  }
  
  func testCrop() {
    let cropRequest = CropRequest.mock()
    
    guard let cropResult = try? imageCropper.crop(cropRequest) else {
      XCTFail()
      return
    }
    
    let croppedImageSize = CGSize(
      width: cropRequest.viewBoundingBox.width,
      height: cropRequest.viewBoundingBox.height
    )
    XCTAssertEqual(cropResult.image.size, croppedImageSize)
    XCTAssertEqual(cropResult.boundingBox, cropRequest.viewBoundingBox)
  }
}
