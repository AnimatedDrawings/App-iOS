//
//  LocalFileProviderTests.swift
//  LocalFileProviderTests
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import LocalRepository
import LocalRepositoryTestings
import ADErrors

final class LocalFileProviderImplTests: XCTestCase {
  var localFileProviderImpl: LocalRepositoryImpl!
  
  override func setUp() {
    localFileProviderImpl = LocalRepositoryImpl()
  }
  
  func testSaveGifSuccess() async {
    let mockPHPhotoLibrary = MockPHPotoLibrary(isSuccess: true)
    localFileProviderImpl = LocalRepositoryImpl(phPhotoLibrary: mockPHPhotoLibrary)
    let fileURL = URL(filePath: "")
    
    do {
      try await localFileProviderImpl.saveGIF(fileUrl: fileURL)
      return
    } catch {
      XCTFail()
    }
  }
  
  func testSaveGifThrowSaveGifInPhotos() async {
    let mockPHPhotoLibrary = MockPHPotoLibrary(isSuccess: false)
    localFileProviderImpl = LocalRepositoryImpl(phPhotoLibrary: mockPHPhotoLibrary)
    let fileURL = URL(filePath: "")
    
    do {
      try await localFileProviderImpl.saveGIF(fileUrl: fileURL)
    } catch let error {
      if let error = error as? LocalFileProviderError,
         error == .saveGifInPhotos {
        return
      }
    }
    
    XCTFail()
  }
  
  func testSaveSuccess() {
    XCTAssertNoThrow(
      try localFileProviderImpl.save(
        data: Data(),
        fileExtension: .gif
      )
    )
  }
  
  func testSaveThrowCreateFile() {
    let fileManager = MockFileManagerFailure()
    localFileProviderImpl = LocalRepositoryImpl(fileManager: fileManager)
    
    do {
      let _ = try localFileProviderImpl.save(data: Data(), fileExtension: .gif)
    } catch let error {
      if let error = error as? LocalFileProviderError,
         error == .createFile
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testReadSuccess() {
    guard let url = URL(string: "https://www.apple.com/") else {
      XCTFail()
      return
    }
    
    do {
      let _ = try localFileProviderImpl.read(from: url)
    } catch {
      XCTFail()
    }
  }
  
  func testReadThrowFetchData() {
    guard let url = URL(string: "fail") else {
      XCTFail()
      return
    }
    
    do {
      let _ = try localFileProviderImpl.read(from: url)
    } catch let error {
      if let error = error as? LocalFileProviderError,
         error == .fetchData
      {
        return
      }
    }
    
    XCTFail()
  }
}
