//
//  LocalFileStorageTests.swift
//  LocalFileStorageTests
//
//  Created by minii on 2023/10/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import LocalFileStorage

final class LocalFileStorageTests: XCTestCase {
  let storage = LocalFileStorage.shared
  
  func testSave() throws {
    let fileURL: URL = try storage.save(with: Data())
    XCTAssertNoThrow(fileURL)
  }
  
  func testRead() throws {
    let fileURL: URL = try storage.save(with: Data())
    let fetchedData: Data = try storage.read(with: fileURL)
    
    XCTAssertNoThrow(fileURL)
    XCTAssertNoThrow(fetchedData)
  }
}
