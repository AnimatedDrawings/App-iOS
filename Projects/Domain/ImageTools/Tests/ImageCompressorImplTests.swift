//
//  ImageCompressorImplTests.swift
//  ImageCompressor
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import ImageTools
import ADResources
import ImageToolsTestings
import ImageToolsInterfaces

final class ImageCompressorImplTests: XCTestCase {
  var example2: UIImage!
  var imageCompressorImpl: ImageCompressorImpl!
  
  override func setUp() async throws {
    example2 = ADResourcesAsset.TestImages.example2.image
    imageCompressorImpl = ImageCompressorImpl()
  }
  
  func testCompressWithDataSuccess() {
    guard let data = example2.pngData() else {
      XCTFail()
      return
    }
          
    XCTAssertNoThrow(try imageCompressorImpl.compress(with: data))
  }
  
  func testCompressWithDataFail() {
    XCTAssertThrowsError(try imageCompressorImpl.compress(with: Data()))
  }
  
  func testCompressWithImageSuccess() {
    XCTAssertNoThrow(try imageCompressorImpl.compress(with: example2))
  }
  
  func testCompressWithImageFail() {
    XCTAssertThrowsError(try imageCompressorImpl.compress(with: UIImage()))
  }
  
  func testReduceFileSizeReturnResult() {
    let result = imageCompressorImpl.reduceFileSize(image: example2)
    XCTAssertNotNil(result)
  }
  
  func testReduceFileSizeReturnNil() {
    let result = imageCompressorImpl.reduceFileSize(image: UIImage())
    XCTAssertNil(result)
  }
  
  func testCompressImage() {
    let maxKB: Double = 2000
    let sizeInBytes = Int(maxKB * 1024)
    guard let compressedData = imageCompressorImpl
      .compressImage(
        with: example2,
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
    let scale = resizeWidth / example2.size.width
    let resizeHeight = example2.size.height * scale
    let resizedImage = imageCompressorImpl.resizeImage(
      with: example2,
      resizeWidth: resizeWidth
    )
    let newSize = CGSize(
      width: resizeWidth,
      height: resizeHeight
    )
    
    XCTAssertNotEqual(example2, resizedImage)
    XCTAssertEqual(resizedImage.size.trunc(), newSize.trunc())
  }
}

final class TestImageCompressorTests: XCTestCase {
  var testImageCompressorImpl: TestImageCompressorImpl!
  
  override func setUp() async throws {
    testImageCompressorImpl = TestImageCompressorImpl()
  }
  
  func testCompress() {
    let mockCompressResponse = CompressResponse.mock()
    
    guard let compressWithData = try? testImageCompressorImpl.compress(with: Data()),
          let compressWithImage = try? testImageCompressorImpl.compress(with: UIImage())
    else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(compressWithData, mockCompressResponse)
    XCTAssertEqual(compressWithImage, mockCompressResponse)
  }
}
