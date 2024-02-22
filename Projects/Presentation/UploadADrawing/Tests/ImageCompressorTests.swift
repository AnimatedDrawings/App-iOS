//
//  ImageCompressorTests.swift
//  UploadADrawingTests
//
//  Created by chminii on 2/22/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import UploadADrawingFeatures
import ADUIKitResources

final class ImageCompressorTests: XCTestCase {
  var image: UIImage!
  var imageCompressor: ImageCompressor!
  
  override func setUp() async throws {
    image = ADUIKitResourcesAsset.TestImages.garlic.image
    imageCompressor = ImageCompressor()
  }
  
  func testCompressWithDataSuccess() {
    guard let data = image.pngData() else {
      XCTFail()
      return
    }
          
    XCTAssertNoThrow(try imageCompressor.compress(with: data))
  }
  
  func testCompressWithDataFail() {
    XCTAssertThrowsError(try imageCompressor.compress(with: Data()))
  }
  
  func testCompressWithImageSuccess() {
    XCTAssertNoThrow(try imageCompressor.compress(with: image))
  }
  
  func testCompressWithImageFail() {
    XCTAssertThrowsError(try imageCompressor.compress(with: UIImage()))
  }
  
  func testReduceFileSizeReturnResult() {
    let result = imageCompressor.reduceFileSize(image: image)
    XCTAssertNotNil(result)
  }
  
  func testReduceFileSizeReturnNil() {
    let result = imageCompressor.reduceFileSize(image: UIImage())
    XCTAssertNil(result)
  }
  
  func testCompressImage() {
    let maxKB: Double = 2000
    let sizeInBytes = Int(maxKB * 1024)
    guard let compressedData = imageCompressor
      .compressImage(
        with: image,
        maxKB: maxKB
      )
    else {
      XCTFail()
      return
    }
    
    XCTAssert(compressedData.count < sizeInBytes)
  }
  
  func testResizeImage() {
    let resizeWidth: Double = 600
    let scale = resizeWidth / image.size.width
    let resizeHeight = image.size.height * scale
    let resizedImage = imageCompressor.resizeImage(
      with: image,
      resizeWidth: resizeWidth
    )
    let newSize = CGSize(
      width: resizeWidth,
      height: resizeHeight
    )
    
    XCTAssertNotEqual(image, resizedImage)
    XCTAssertEqual(resizedImage.size, newSize)
  }
  
  func testTestImageCompressor() {
    let testImageCompressor = TestImageCompressor()
    let image = ADUIKitResourcesAsset.TestImages.garlic.image
    guard let data = image.pngData() else {
      XCTFail()
      return
    }
    let mockCompressedInfo = CompressedInfo(data: data, image: image, original: image)
    
    guard let compressWithData = try? testImageCompressor.compress(with: data),
          let compressWithImage = try? testImageCompressor.compress(with: image)
    else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(compressWithData, mockCompressedInfo)
    XCTAssertEqual(compressWithImage, mockCompressedInfo)
  }
}
