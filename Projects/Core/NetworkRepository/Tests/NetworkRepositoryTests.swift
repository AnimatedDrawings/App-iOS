//
//  NetworkRepositoryTests.swift
//  NetworkRepositoryTests
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkRepository

struct TestEncodable: Encodable {
  let string = "test"
  let int = 1
}

final class NetworkRepositoryTests: XCTestCase {
  func testEncodableToDictionary() {
    // given
    let testEncodable = TestEncodable()
    
    // when, then
    do {
      let dictionary = try testEncodable.toDict()
      print(dictionary)
    } catch {
      XCTFail("error: \(error)")
    }
  }
}

