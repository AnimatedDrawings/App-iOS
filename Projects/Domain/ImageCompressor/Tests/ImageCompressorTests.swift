//
//  ImageCompressorTests.swift
//  ImageCompressor
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import ImageCompressor
import ADUIKitResources
import DomainModel

final class ImageCompressorTests: XCTestCase {
  var garlic: UIImage!
  var imageCompressor: ImageCompressor!
  
  override func setUp() async throws {
    garlic = ADUIKitResourcesAsset.TestImages.garlic.image
    imageCompressor = ImageCompressor()
  }
  
  func testCompressWithDataSuccess() {
    guard let data = garlic.pngData() else {
      XCTFail()
      return
    }
          
    XCTAssertNoThrow(try imageCompressor.compress(with: data))
  }
  
  func testCompressWithDataFail() {
    XCTAssertThrowsError(try imageCompressor.compress(with: Data()))
  }
  
  func testCompressWithImageSuccess() {
    XCTAssertNoThrow(try imageCompressor.compress(with: garlic))
  }
  
  func testCompressWithImageFail() {
    XCTAssertThrowsError(try imageCompressor.compress(with: UIImage()))
  }
  
  func testReduceFileSizeReturnResult() {
    let result = imageCompressor.reduceFileSize(image: garlic)
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
        with: garlic,
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
    let scale = resizeWidth / garlic.size.width
    let resizeHeight = garlic.size.height * scale
    let resizedImage = imageCompressor.resizeImage(
      with: garlic,
      resizeWidth: resizeWidth
    )
    let newSize = CGSize(
      width: resizeWidth,
      height: resizeHeight
    )
    
    XCTAssertNotEqual(garlic, resizedImage)
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

